import Foundation
import Logging


/// Query the current Utxo set, restricted to some output references or addresses.
public struct QueryLedgerStateUtxo {
    private let client: OgmiosClient
    
    private static let method: String = "queryLedgerState/utxo"
    private static let jsonrpc: String = JSONRPCVersion
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Params
    public enum Params: JSONSerializable, Sendable {
        case outputReferences([TransactionOutputReference])
        case addresses([Address])
        case wholeUtxo
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let outputReferences = try? container.decode([TransactionOutputReference].self, forKey: .outputReferences) {
                self = .outputReferences(outputReferences)
            } else if let addresses = try? container.decode([Address].self, forKey: .addresses) {
                self = .addresses(addresses)
            } else {
                self = .wholeUtxo
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .outputReferences(let refs):
                try container.encode(refs, forKey: .outputReferences)
            case .addresses(let addrs):
                try container.encode(addrs, forKey: .addresses)
            case .wholeUtxo:
                break
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case outputReferences
            case addresses
        }
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Params?
        public let id: JSONRPCId?
        
        init(params: Params? = nil, id: JSONRPCId? = nil) {
            self.id = id
            self.method = QueryLedgerStateUtxo.method
            self.jsonrpc = QueryLedgerStateUtxo.jsonrpc
            self.params = params
        }
    }
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: Utxo
        public let id: JSONRPCId?
        
        init(result: Utxo, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = QueryLedgerStateUtxo.method
            self.jsonrpc = QueryLedgerStateUtxo.jsonrpc
        }
    }
    
    // MARK: - Public Methods
    public func execute(params: Params? = nil, id: JSONRPCId? = nil) async throws -> Response {
        let data = try await self.send(params: params, id: id)
        return try await self.process(data: data)
    }
    
    // Convenience methods for specific parameter types
    public func execute(outputReferences: [TransactionOutputReference], id: JSONRPCId? = nil) async throws -> Response {
        return try await execute(params: .outputReferences(outputReferences), id: id)
    }
    
    public func execute(addresses: [Address], id: JSONRPCId? = nil) async throws -> Response {
        return try await execute(params: .addresses(addresses), id: id)
    }
    
    public func execute(wholeUtxo: Bool = true, id: JSONRPCId? = nil) async throws -> Response {
        return try await execute(params: .wholeUtxo, id: id)
    }
    
    // MARK: - Private Methods
    private func send(params: Params? = nil, id: JSONRPCId? = nil) async throws -> Data {
        let request = Request(params: params, id: id)
        return try await client.sendRequestJSON(request)
    }
    
    private func process(data: Data) async throws -> Response {
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let responseJSON = responseJSON else {
            throw OgmiosError.invalidResponse("Response is not a valid JSON object")
        }
        
        guard let method = responseJSON["method"] as? String,
              method == QueryLedgerStateUtxo.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(QueryLedgerStateUtxo.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let code = error["code"] as? Int {
            
            let response: any JSONRPCResponseError
            if code == 2001 {
                response = try QueryLedgerStateEraMismatch.fromJSONData(data)
            } else if code == 2002 {
                response = try QueryLedgerStateUnavailableInCurrentEra.fromJSONData(data)
            } else if code == 2003 {
                response = try QueryLedgerStateAcquiredExpired.fromJSONData(data)
            } else {
                throw OgmiosError
                    .responseError("Ogmios returned an unknown error code: \(code)")
            }
            
            client.logResponseError(response: response)
            throw OgmiosError
                .responseError(
                    "Ogmios returned an error: \(String(describing: response.error?.message))"
                )
        }
        
        let response = try Response.fromJSONData(data)
        client.logResponse(response: response)
        
        return response
    }
}
