import Foundation
import Logging

/// Query the network start time.
public struct QueryNetworkStartTime {
    private let client: OgmiosClient
    
    private static let method: String = "queryNetwork/startTime"
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
            self.method = QueryNetworkStartTime.method
            self.jsonrpc = QueryNetworkStartTime.jsonrpc
            self.params = nil
        }
    }
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: UtcTime
        public let id: JSONRPCId?
        
        init(result: UtcTime, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = QueryNetworkStartTime.method
            self.jsonrpc = QueryNetworkStartTime.jsonrpc
        }
    }
    
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil) async throws -> UtcTime {
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
              method == QueryNetworkStartTime.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(QueryNetworkStartTime.method) response: \(responseJSON["method"] ?? "nil")")
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
