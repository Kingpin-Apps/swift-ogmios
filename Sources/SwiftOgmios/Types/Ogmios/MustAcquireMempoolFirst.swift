import Foundation

/// Error returned when trying to perform mempool operations without first acquiring a mempool snapshot
public struct MustAcquireMempoolFirst: JSONRPCResponseError {
    public let jsonrpc: String
    public let method: String
    public let error: MustAcquireMempoolFirstError
    public let id: JSONRPCId?
    
    public struct MustAcquireMempoolFirstError: JSONRPCError {
        public let code: Int
        public let message: String
        
        init(code: Int = 4000, message: String) {
            self.code = code
            self.message = message
        }
    }
    
    init(
        method: String,
        error: MustAcquireMempoolFirstError,
        id: JSONRPCId? = nil,
        jsonrpc: String = JSONRPCVersion,
    ) {
        self.id = id
        self.method = method
        self.error = error
        self.jsonrpc = jsonrpc
    }
}
