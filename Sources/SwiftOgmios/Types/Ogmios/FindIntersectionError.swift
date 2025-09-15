import Foundation

// MARK: - FindIntersectionError Wrapper

public struct FindIntersectionError<T: FindIntersectionFailure>: JSONRPCResponseError {
    public let jsonrpc: String
    public let method: String
    public let error: T
    public let id: JSONRPCId?
    
    public init(
        method: String = "findIntersection",
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

// MARK: - FindIntersectionFailure Protocol

public protocol FindIntersectionFailure: JSONRPCError {}

/// No intersection found with the requested points.
/// Error code: 1000
public struct IntersectionNotFound: FindIntersectionFailure {
    public let code: Int
    public let message: String
    public let data: IntersectionNotFoundData
    
    public struct IntersectionNotFoundData: JSONSerializable {
        public let tip: TipOrOrigin
    }
    
    init(code: Int = 1000, message: String, data: IntersectionNotFoundData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// An internal error indicating that requests were interleaved in an unexpected way.
/// Error code: 1001
public struct FindIntersectionIntersectionInterleaved: FindIntersectionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 1001, message: String) {
        self.code = code
        self.message = message
    }
}
