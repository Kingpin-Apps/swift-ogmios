import Foundation

public struct QueryLedgerStateEraMismatch: JSONRPCResponseError {
    public let jsonrpc: String
    public let method: String
    public let error: QueryLedgerStateEraMismatchError?
    public let id: JSONRPCId?
    
    public struct QueryLedgerStateEraMismatchData: Codable, Hashable, Sendable {
        public let queryEra: String
        public let ledgerEra: String
    }
    
    public struct QueryLedgerStateEraMismatchError: JSONRPCError {
        public let code: Int
        public let message: String
        public let data: QueryLedgerStateEraMismatchData
    }
    
    init(
        method: String,
        error: QueryLedgerStateEraMismatchError,
        id: JSONRPCId? = nil,
        jsonrpc: String = "2.0",
    ) {
        self.id = id
        self.method = method
        self.error = error
        self.jsonrpc = jsonrpc
    }
}
