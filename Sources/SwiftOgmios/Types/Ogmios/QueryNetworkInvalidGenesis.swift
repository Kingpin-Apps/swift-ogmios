import Foundation


public struct QueryNetworkInvalidGenesis: JSONRPCResponseError {
    public let jsonrpc: String
    public let method: String
    public let error: QueryNetworkInvalidGenesisError?
    public let id: JSONRPCId?
    
    /// Something went wrong (e.g. misconfiguration) in reading genesis file for the latest era.
    public struct QueryNetworkInvalidGenesisError: JSONRPCError {
        public let code: Int
        public let message: String
        
        /// A reason for the failure.
        public let data: String?
        
        public init(code: Int, message: String, data: String?) {
//            guard code == 2004 else {
//                fatalError("Invalid JSON-RPC error code: \(code)")
//            }
            self.code = code
            self.message = message
            self.data = data
        }
    }
    
    init(
        method: String,
        error: QueryNetworkInvalidGenesisError,
        id: JSONRPCId? = nil,
        jsonrpc: String = JSONRPCVersion,
    ) {
        self.id = id
        self.method = method
        self.error = error
        self.jsonrpc = jsonrpc
    }
}

