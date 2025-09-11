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

// MARK: - OgmiosClient

public class OgmiosClient: @unchecked Sendable, Loggable {
    
    // MARK: - Properties
    
    private let transport: JSONRPCTransport
    private var session: URLSession {
        return URLSession(configuration: self.configuration)
    }
    
    private var httpConnection: (any HTTPConnectable)?
    private var webSocketConnection: (any WebSocketConnectable)?
    
    weak var delegate: JSONRPCTransportDelegate?
    
    private let host: String
    private let port: Int
    private let path: String
    private let secure: Bool
    private let httpOnly: Bool
    private let rpcVersion: String
    private let configuration: URLSessionConfiguration
    
    internal let logger: Logger
    
    public var ledgerStateQuery: LedgerStateQuery {
        return LedgerStateQuery(client: self)
    }
    
    // MARK: - Initialization
    init(
        host: String = "localhost",
        port: Int = 1337,
        path: String = "",
        secure: Bool = false,
        httpOnly: Bool = false,
        rpcVersion: String = "2.0",
        configuration: URLSessionConfiguration = .default,
        httpConnection: (any HTTPConnectable)? = nil,
        webSocketConnection: (any WebSocketConnectable)? = nil
    ) async throws{
        self.host = host
        self.port = port
        self.path = path
        self.secure = secure
        self.httpOnly = httpOnly
        self.rpcVersion = rpcVersion
        
        if self.httpOnly {
            self.transport = self.secure ?
                .https(URL(string: "https://\(host):\(port)/\(path)")!) :
                .http(URL(string: "http://\(host):\(port)/\(path)")!)
        } else {
            self.transport = self.secure ?
                .wss(URL(string: "wss://\(host):\(port)/\(path)")!) :
                .ws(URL(string: "ws://\(host):\(port)/\(path)")!)
        }
        
        self.configuration = configuration
        
        self.logger = Logger(label: "com.swift-ogmios")
        setupLogging()
        
        try await connect(
            httpConnection: httpConnection,
            webSocketConnection: webSocketConnection
        )
    }
    
    deinit {
        disconnect()
    }
    
    // MARK: - Connection Management
    
    func connect(
        httpConnection: (any HTTPConnectable)? = nil,
        webSocketConnection: (any WebSocketConnectable)? = nil
    ) async throws {
        switch transport {
            case .ws(let url), .wss(let url):
                self.webSocketConnection = webSocketConnection ?? WebSocketConnection(url: url, session: session)
            case .http(let url), .https(let url):
                self.httpConnection = httpConnection ?? HTTPConnection(url: url, session: session)
        }
        delegate?.transportDidConnect()
    }
    
    func disconnect() {
        webSocketConnection?.close()
        webSocketConnection = nil
        delegate?.transportDidDisconnect()
    }
        
    public func sendRequestJSON(_ request: any JSONRPCRequest) async throws -> Data {
        let requestJSON = try request.toJSONString()
        
        switch transport {
            case .http(_), .https(_):
                guard let httpConnection = httpConnection else {
                    throw OgmiosError.httpError("HTTPConnection not initiated")
                }
                return try await httpConnection.sendRequest(json: requestJSON)
            case .ws(_), .wss(_):
                guard let webSocketConnection = webSocketConnection else {
                    throw OgmiosError.websocketError("WebSocket not connected")
                }
                return try await webSocketConnection.sendRequest(json: requestJSON)
        }
    }
    
    public func getServerHealth(httpConnection: (any HTTPConnectable)? = nil) async throws -> Health {
        let healthCheckURL: URL
        switch transport {
            case .http(let url), .https(let url):
                healthCheckURL = url.appending(path: "health")
            case .ws(let url):
                healthCheckURL = URL(string: url.absoluteString.replacingOccurrences(of: "ws", with: "http"))!.appendingPathComponent("health")
            case .wss(let url):
                healthCheckURL = URL(string: url.absoluteString.replacingOccurrences(of: "wss", with: "https"))!.appendingPathComponent("health")
        }
        
        let responseData: Data
        if httpConnection == nil {
            responseData = try await HTTPConnection(
                url: healthCheckURL,
                session: session
            ).get(url: healthCheckURL)
        } else {
            responseData = try await httpConnection!.get(url: healthCheckURL)
        }
        
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
        
        public var governanceProposals: QueryLedgerStateGovernanceProposals {
            return QueryLedgerStateGovernanceProposals(client: self.client)
        }
        
        public var liveStakeDistribution: QueryLedgerStateLiveStakeDistribution {
            return QueryLedgerStateLiveStakeDistribution(client: self.client)
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
