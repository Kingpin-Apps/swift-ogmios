import Foundation

public struct EvaluateTransactionError<T: EvaluateTransactionFailure>: JSONRPCResponseError {
    public let jsonrpc: String
    public let method: String
    public let error: T
    public let id: JSONRPCId?
    
    public init(
        method: String = "evaluateTransaction",
        error: T,
        id: JSONRPCId? = nil,
        jsonrpc: String = JSONRPCVersion
    ) {
        self.id = id
        self.method = method
        self.error = error
        self.jsonrpc = jsonrpc
    }
}