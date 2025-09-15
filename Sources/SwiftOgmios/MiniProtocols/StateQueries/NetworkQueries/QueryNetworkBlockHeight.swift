import Foundation
import Logging

/// Query the network’s highest block number.
public struct QueryNetworkBlockHeight {
    private let client: OgmiosClient
    
    private static let method: String = "queryNetwork/blockHeight"
    private static let jsonrpc: String = JSONRPCVersion
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Never?
        public let id: JSONRPCId?
        
        init(id: JSONRPCId? = nil) {
            self.id = id
            self.method = QueryNetworkBlockHeight.method
            self.jsonrpc = QueryNetworkBlockHeight.jsonrpc
            self.params = nil
        }
    }
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: BlockHeightOrOrigin
        public let id: JSONRPCId?
        
        init(result: BlockHeightOrOrigin, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = QueryNetworkBlockHeight.method
            self.jsonrpc = QueryNetworkBlockHeight.jsonrpc
        }
    }
    
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil) async throws -> BlockHeightOrOrigin {
        let response = try await self.execute(id: id)
        return response.result
    }
    
    public func execute(id: JSONRPCId? = nil) async throws -> Response {
        let data = try await self.send(id: id)
        return try await self.process(data: data)
    }
    
    // MARK: - Private Methods
    private func send(id: JSONRPCId? = nil) async throws -> Data {
        let request = Request(id: id)
        return try await client.sendRequestJSON(request)
    }
    
    private func process(data: Data) async throws -> Response {
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let responseJSON = responseJSON else {
            throw OgmiosError.invalidResponse("Response is not a valid JSON object")
        }
        
        guard let method = responseJSON["method"] as? String,
              method == QueryNetworkBlockHeight.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(QueryNetworkBlockHeight.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let _ = error["code"] as? Int {
            throw OgmiosError
                .responseError("Ogmios returned an unknown response: \(responseJSON)")
        }
        
        let response = try Response.fromJSONData(data)
        client.logResponse(response: response)
        
        return response
    }
}
