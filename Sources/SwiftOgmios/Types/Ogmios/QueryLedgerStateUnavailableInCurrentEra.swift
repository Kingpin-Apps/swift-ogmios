import Foundation

public struct QueryLedgerStateUnavailableInCurrentEra: JSONRPCResponseError {
    public let jsonrpc: String
    public let method: String
    public let error: QueryLedgerStateUnavailableInCurrentEraError?
    public let id: JSONRPCId?
    
    public struct QueryLedgerStateUnavailableInCurrentEraError: JSONRPCError {
        public let code: Int
        public let message: String
    }
    
    init(
        method: String,
        error: QueryLedgerStateUnavailableInCurrentEraError,
        id: JSONRPCId? = nil,
        jsonrpc: String = "2.0",
    ) {
        self.id = id
        self.method = method
        self.error = error
        self.jsonrpc = jsonrpc
    }
}
