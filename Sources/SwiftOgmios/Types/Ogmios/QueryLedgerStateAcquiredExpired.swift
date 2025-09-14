import Foundation

public struct QueryLedgerStateAcquiredExpired: JSONRPCResponseError {
    public let jsonrpc: String
    public let method: String
    public let error: QueryLedgerStateAcquiredExpiredError
    public let id: JSONRPCId?
    
    public struct QueryLedgerStateAcquiredExpiredError: JSONRPCError {
        public let code: Int
        public let message: String
        public let data: String
    }
    
    init(
        method: String,
        error: QueryLedgerStateAcquiredExpiredError,
        id: JSONRPCId? = nil,
        jsonrpc: String = "2.0",
    ) {
        self.id = id
        self.method = method
        self.error = error
        self.jsonrpc = jsonrpc
    }
}



