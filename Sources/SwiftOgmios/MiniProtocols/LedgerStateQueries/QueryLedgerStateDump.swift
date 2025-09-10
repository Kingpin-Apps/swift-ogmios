import Foundation
import Logging


/// Get a dump of the entire Cardano ledger state (CBOR) corresponding to the 'NewEpochState'.
/// Takes some time.
public struct QueryLedgerStateDump {
    private let client: OgmiosClient
    
    private static let method: String = "queryLedgerState/dump"
    private static let jsonrpc: String = "2.0"
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Params?
        public let id: JSONRPCId?
        
        init(id: JSONRPCId? = nil, params: Params? = nil) {
            self.id = id
            self.method = QueryLedgerStateDump.method
            self.jsonrpc = QueryLedgerStateDump.jsonrpc
            self.params = params
        }
    }
    
    public struct Params: JSONSerializable, Sendable {
        /// A filepath to dump the ledger state to disk, relative to the server's location.
        public let to: String
    }
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: Never?
        public let id: JSONRPCId?
        
        init(result: Never? = nil, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = QueryLedgerStateDump.method
            self.jsonrpc = QueryLedgerStateDump.jsonrpc
        }
    }
    
    // MARK: - Public Methods
    public func execute(id: JSONRPCId? = nil, params: Params? = nil) async throws -> Response {
        let data = try await self.send(id: id, params: params)
        return try await self.process(data: data)
    }
    
    // MARK: - Private Methods
    private func send(id: JSONRPCId? = nil, params: Params? = nil) async throws -> Data {
        let request = Request(id: id, params: params)
        return try await client.sendRequestJSON(request)
    }
    
    private func process(data: Data) async throws -> Response {
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let responseJSON = responseJSON else {
            throw OgmiosError.invalidResponse("Response is not a valid JSON object")
        }
        
        guard let method = responseJSON["method"] as? String,
                method == QueryLedgerStateDump.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(QueryLedgerStateDump.method) response: \(responseJSON["method"] ?? "nil")")
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


