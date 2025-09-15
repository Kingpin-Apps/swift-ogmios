import Foundation
import Logging


/// Acquire a mempool snapshot. This is blocking until a new (i.e different) snapshot is available.
public struct AcquireMempool {
    private let client: OgmiosClient
    
    private static let method: String = "acquireMempool"
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
            self.method = AcquireMempool.method
            self.jsonrpc = AcquireMempool.jsonrpc
            self.params = nil
        }
    }
    
    // MARK: - Response
    /// Response to a 'acquireMempool' request.
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: Result
        public let id: JSONRPCId?
        
        init(result: Result, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = AcquireMempool.method
            self.jsonrpc = AcquireMempool.jsonrpc
        }
    }
    
    // MARK: - Result
    public struct Result: JSONSerializable {
        public let acquired: String
        public let slot: Slot
        
        init(acquired: String = "mempool", slot: Slot) {
            self.acquired = acquired
            self.slot = slot
        }
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
                method == AcquireMempool.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(AcquireMempool.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let code = error["code"] as? Int {
            throw OgmiosError
                .responseError("Ogmios returned an unknown error code: \(code)")
        }
        
        let response = try Response.fromJSONData(data)
        client.logResponse(response: response)
        
        return response
    }
}
