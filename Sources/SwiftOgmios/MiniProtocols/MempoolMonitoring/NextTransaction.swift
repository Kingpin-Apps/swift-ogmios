import Foundation
import Logging


/// Request the next transaction from an acquired mempools napshot.
public struct NextTransaction {
    private let client: OgmiosClient
    
    private static let method: String = "nextTransaction"
    private static let jsonrpc: String = JSONRPCVersion
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Params?
        public let id: JSONRPCId?
        
        public init(id: JSONRPCId? = nil, params: Params? = nil) {
            self.id = id
            self.method = NextTransaction.method
            self.jsonrpc = NextTransaction.jsonrpc
            self.params = params
        }
    }
    
    // MARK: - Params
    public struct Params: JSONSerializable {
        public let fields: String
        
        public init(fields: String = "all") {
            self.fields = fields
        }
    }

    
    // MARK: - Response
    /// Response to a 'NextTransaction' request.
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: Result
        public let id: JSONRPCId?
        
        public init(result: Result, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = NextTransaction.method
            self.jsonrpc = NextTransaction.jsonrpc
        }
    }
    
    // MARK: - Result
    /// A transaction (or id) or an empty object if there's no more transactions.
    public struct Result: JSONSerializable {
        public let transaction: NextTransactionResult
        
        public init(transaction: NextTransactionResult) {
            self.transaction = transaction
        }
    }
    
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil, params: Params? = nil) async throws -> Result {
        let response = try await self.execute(id: id, params: params)
        return response.result
    }
    
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
                method == NextTransaction.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(NextTransaction.method) response: \(responseJSON["method"] ?? "nil")")
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
