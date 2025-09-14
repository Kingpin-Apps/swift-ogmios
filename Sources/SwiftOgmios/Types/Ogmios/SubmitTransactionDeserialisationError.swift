import Foundation

public struct SubmitTransactionDeserialisationError: JSONRPCResponseError {
    public let jsonrpc: String
    public let method: String
    public let error: DeserialisationFailure
    public let id: JSONRPCId?
    
    init(
        method: String = "submitTransaction",
        error: DeserialisationFailure,
        id: JSONRPCId? = nil,
        jsonrpc: String = JSONRPCVersion,
    ) {
        self.id = id
        self.method = method
        self.error = error
        self.jsonrpc = jsonrpc
    }
}



