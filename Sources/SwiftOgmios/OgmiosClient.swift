import Foundation
import Network
import PotentCodables
import Logging


// MARK: - Transport Protocol

enum JSONRPCTransport {
    case http(URL)
    case https(URL)
    case ws(URL)
    case wss(URL)
    
    public var url: URL {
        switch self {
            case .http(let url), .https(let url), .ws(let url), .wss(let url):
                return url
        }
    }
}

protocol JSONRPCTransportDelegate: AnyObject, Sendable {
    func transportDidConnect()
    func transportDidDisconnect()
    func transportDidReceiveResponse(_ data: Data)
    func transportDidEncounterError(_ error: Error)
}

// MARK: - Main JSON-RPC Client

public class OgmiosClient: @unchecked Sendable, Loggable {
    
    // MARK: - Properties
    
    private let transport: JSONRPCTransport
    private let session: URLSession
    private var webSocketConnection: WebSocketConnection?
    private var pendingRequests: [JSONRPCId: CheckedContinuation<Data, Error>] = [:]
    private let queue = DispatchQueue(label: "jsonrpc.client.queue", attributes: .concurrent)
    private var requestIdCounter: Int = 0
    
    weak var delegate: JSONRPCTransportDelegate?
    
    private let host: String
    private let port: Int
    private let path: String
    private let secure: Bool
    private let httpOnly: Bool
    private let rpcVersion: String
    private let additionalHeaders: Dictionary<String, String>?
    
    internal let logger: Logger
    
    public var ledgerStateQuery: LedgerStateQuery {
        return LedgerStateQuery(client: self)
    }
    
    // MARK: - Initialization
    convenience init(
        host: String = "localhost",
        port: Int = 1337,
        path: String = "",
        secure: Bool = false,
        httpOnly: Bool = false,
        rpcVersion: String = "2.0",
        additionalHeaders: Dictionary<String, String> = [:]
    ) async throws{
        let transport: JSONRPCTransport
        if httpOnly {
            transport = secure ? .https(URL(string: "https://\(host):\(port)/\(path)")!) : .http(URL(string: "http://\(host):\(port)/\(path)")!)
        } else {
            transport = secure ? .wss(URL(string: "wss://\(host):\(port)/\(path)")!) : .ws(URL(string: "ws://\(host):\(port)/\(path)")!)
        }
            
        try await self.init(transport: transport, configuration: .default)
    }

    
    init(transport: JSONRPCTransport, configuration: URLSessionConfiguration = .default) async throws {
        self.transport = transport
        self.session = URLSession(configuration: configuration)
        
        self.host = transport.url.host!
        self.port = transport.url.port ?? (transport.url.scheme == "https" || transport.url.scheme == "wss" ? 443 : 80)
        self.path = transport.url.path
        self.secure = (transport.url.scheme == "https" || transport.url.scheme == "wss")
        self.httpOnly = (transport.url.scheme == "http" || transport.url.scheme == "https")
        self.rpcVersion = "2.0"
        self.additionalHeaders = configuration.httpAdditionalHeaders as? Dictionary<String, String>
        
        self.logger = Logger(label: "com.swift-ogmios")
        setupLogging()
        
        try await connect()
    }
    
    deinit {
        disconnect()
    }
    
    // MARK: - Connection Management
    
    func connect() async throws {
        switch transport {
        case .ws(let url), .wss(let url):
            try await connectWebSocket(url: url)
        case .http(_), .https(_):
            // HTTP/HTTPS don't require persistent connections
            delegate?.transportDidConnect()
        }
    }
    
    func disconnect() {
        webSocketConnection?.close()
        webSocketConnection = nil
        delegate?.transportDidDisconnect()
    }
    
    private func connectWebSocket(url: URL) async throws {
        let webSocketTask = session.webSocketTask(with: url)
        webSocketConnection = WebSocketConnection(
            webSocketTask: webSocketTask
        )
        
        delegate?.transportDidConnect()
    }
    
    private func handleWebSocketResponse(_ data: Data) {
        do {
            let genericResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let id = genericResponse?["id"] as? Int {
                queue.async(flags: .barrier) {
                    if let continuation = self.pendingRequests.removeValue(
                        forKey: JSONRPCId.number(id)
                    ) {
                        continuation.resume(returning: data)
                    }
                }
            }
        } catch {
            delegate?.transportDidEncounterError(error)
        }
    }
    
    public func sendRequestData(_ request: any JSONRPCRequest) async throws -> Data {
        let requestData = try JSONEncoder().encode(request)
        
        switch transport {
            case .http(let url), .https(let url):
                return try await sendHTTPRequest(data: requestData, url: url)
            case .ws(_), .wss(_):
                return try await sendWebSocketRequest(data: requestData, id: request.id)
        }
    }
    
    public func sendRequestJSON(_ request: any JSONRPCRequest) async throws -> Data {
        let requestJSON = try request.toJSONString()
        
        switch transport {
            case .http(let url), .https(let url):
                return try await sendHTTPRequest(json: requestJSON, url: url)
            case .ws(_), .wss(_):
                return try await sendWebSocketRequest(json: requestJSON, id: request.id)
        }
    }
        
    private func sendHTTPRequest(json: String, url: URL) async throws -> Data {
        guard let jsonData = json.data(using: .utf8) else {
            throw OgmiosError.invalidJSONError("Invalid JSON string: \(json)")
        }
        return try await self.sendHTTPRequest(data: jsonData, url: url)
    }
    
    private func sendHTTPRequest(data: Data, url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let (responseData, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OgmiosError.invalidResponse("Invalid HTTP response: \(String(describing: response))")
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw OgmiosError.httpError("HTTP error: \(httpResponse)")
        }
        
        return responseData
    }
    
    private func sendWebSocketRequest(json: String, id: JSONRPCId?) async throws -> Data {
        guard let webSocketConnection = webSocketConnection else {
            throw OgmiosError.websocketError("WebSocket not connected")
        }
        
        try await webSocketConnection.send(json)
        
        let responseString = try await webSocketConnection.receiveOnce()
        return responseString.data(using: .utf8) ?? Data()
    }
    
    
    private func sendWebSocketRequest(data: Data, id: JSONRPCId?) async throws -> Data {
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "JSONEncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON to string"])
        }
        
        return try await sendWebSocketRequest(json: jsonString, id: id)
    }
    
    public func getNextRequestId() -> Int {
        return queue.sync {
            requestIdCounter += 1
            return requestIdCounter
        }
    }
    
    public func getServerHealth() async throws -> Health {
        let healthCheckURL: URL
        switch transport {
            case .http(let url), .https(let url):
                healthCheckURL = url.appending(path: "health")
            case .ws(let url):
                healthCheckURL = URL(string: url.absoluteString.replacingOccurrences(of: "ws", with: "http"))!.appendingPathComponent("health")
            case .wss(let url):
                healthCheckURL = URL(string: url.absoluteString.replacingOccurrences(of: "wss", with: "https"))!.appendingPathComponent("health")
        }
        
        var request = URLRequest(url: healthCheckURL)
        request.httpMethod = "GET"
        
        let (responseData, _) = try await session.data(for: request)
        
        return try JSONDecoder().decode(Health.self, from: responseData)
    }
}


// MARK: - Extensions for Mini-Protocols

/// Ogmios Client Extensions for mini-protocols
extension OgmiosClient {
    
    public struct LedgerStateQuery {
        private let client: OgmiosClient
        
        public init(client: OgmiosClient) {
            self.client = client
        }
        
        public var constitution: QueryLedgerStateConstitution {
            return QueryLedgerStateConstitution(client: self.client)
        }
        
        public var constitutionalCommittee: QueryLedgerStateConstitutionalCommittee {
            return QueryLedgerStateConstitutionalCommittee(client: self.client)
        }
        
        public var delegateRepresentatives: QueryLedgerStateDelegateRepresentatives {
            return QueryLedgerStateDelegateRepresentatives(client: self.client)
        }
        
        public var dump: QueryLedgerStateDump {
            return QueryLedgerStateDump(client: self.client)
        }
        
        public var epoch: QueryLedgerStateEpoch {
            return QueryLedgerStateEpoch(client: self.client)
        }
        
        public var eraStart: QueryLedgerStateEraStart {
            return QueryLedgerStateEraStart(client: self.client)
        }
        
        public var eraSummaries: QueryLedgerStateEraSummaries {
            return QueryLedgerStateEraSummaries(client: self.client)
        }
        
        public var tip: QueryLedgerStateTip {
            return QueryLedgerStateTip(client: self.client)
        }
    }
    
    public struct ChainSync {
        private let client: OgmiosClient
        
        public init(client: OgmiosClient) {
            self.client = client
        }
    }
    
    public struct TransactionSubmission {
        private let client: OgmiosClient
        
        public init(client: OgmiosClient) {
            self.client = client
        }
    }
    
    public struct MempoolMonitor {
        private let client: OgmiosClient
        
        public init(client: OgmiosClient) {
            self.client = client
        }
    }
}
