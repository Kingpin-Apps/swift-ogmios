import Foundation
import Logging


/// Get size and capacities of the mempool (acquired snapshot).
public struct SizeOfMempool {
    private let client: OgmiosClient
    
    private static let method: String = "sizeOfMempool"
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
        
        public init(id: JSONRPCId? = nil) {
            self.id = id
            self.method = SizeOfMempool.method
            self.jsonrpc = SizeOfMempool.jsonrpc
            self.params = nil
        }
    }
    
    // MARK: - Response
    /// Response to a 'SizeOfMempool' request.
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: Result
        public let id: JSONRPCId?
        
        public init(result: Result, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = SizeOfMempool.method
            self.jsonrpc = SizeOfMempool.jsonrpc
        }
    }
    
    // MARK: - Result
    public struct Result: JSONSerializable {
        public let maxCapacity: BytesWrapper
        public let currentSize: BytesWrapper
        public let transactions: CountWrapper
    }
    
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil) async throws -> Result {
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
              method == SizeOfMempool.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(SizeOfMempool.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let code = error["code"] as? Int {
            
            let response: any JSONRPCResponseError
            if code == 4000 {
                response = try MustAcquireMempoolFirst.fromJSONData(data)
            } else {
                throw OgmiosError
                    .responseError("Ogmios returned an unknown error code: \(code)")
            }
            
            client.logResponseError(response: response)
            throw OgmiosError
                .responseError(
                    "Ogmios returned an error: \(String(describing: response.error.message))"
                )
        }
        
        let response = try Response.fromJSONData(data)
        client.logResponse(response: response)
        
        return response
    }
}
