import Foundation
import Network

public let JSONRPCVersion = "2.0"

// MARK: - JSON-RPC Protocol Structures
public protocol JSONSerializable: Codable, Equatable, Hashable, CustomDebugStringConvertible, CustomStringConvertible, Sendable {
}

extension JSONSerializable {
    public static func fromJSONData(_ data: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
    public static func fromJSONString(_ jsonString: String) throws -> Self {
        guard let data = jsonString.data(using: .utf8) else {
            throw OgmiosError.invalidJSONError("Invalid JSON string: \(jsonString)")
        }
        return try Self.fromJSONData(data)
    }
    
    public func toJSONString() throws -> String {
        let data = try self.toJSONData()
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw OgmiosError.encodingError("Failed to encode JSON to string: \(self)")
        }
        return jsonString
    }
    
    public func toJSONData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        return try encoder.encode(self)
    }
    
    public var debugDescription: String {
        (try? toJSONString()) ?? String(describing: self)
    }
    
    public var description: String {
        debugDescription
    }
}

// MARK: - JSON-RPC Request
/// JSON-RPC 2.0 Request
public protocol JSONRPCRequest: JSONSerializable {
    associatedtype T: Codable
    
    var jsonrpc: String { get }
    var method: String { get }
    var params: T { get }
    
    /// An arbitrary JSON value that will be mirrored back in the response.
    var id: JSONRPCId? { get }
}

// MARK: - JSON-RPC Response
/// JSON-RPC 2.0 Response
public protocol JSONRPCResponse: JSONSerializable {
    associatedtype T: Codable
    
    var jsonrpc: String { get }
    var method: String { get }
    var result: T { get }
    
    /// Any value that was set by a client request in the 'id' field.
    var id: JSONRPCId? { get }
}

// MARK: - JSON-RPC Response Error
public protocol JSONRPCResponseError: JSONSerializable {
    associatedtype T: JSONRPCError
    
    var jsonrpc: String { get }
    var method: String { get }
    var error: T { get }
    var id: JSONRPCId? { get }
}

// MARK: - JSON-RPC Error
/// JSON-RPC 2.0 Error
public protocol JSONRPCError: JSONSerializable {
    var code: Int { get }
    var message: String { get }
}

// MARK: - JSON-RPC ID
/// JSON-RPC ID can be string, number, or null
public enum JSONRPCId: JSONSerializable {
    case string(String)
    case number(Int)
    case null
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .number(intValue)
        } else {
            throw DecodingError.typeMismatch(JSONRPCId.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid JSON-RPC ID"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
    
    /// Generate a new unique JSONRPCId using current timestamp in milliseconds
    public static func generateNextNumber() -> JSONRPCId {
        return .number(Int(Date().timeIntervalSince1970 * 1000))
    }
    
    /// Generate a new unique JSONRPCId using UUID string
    public static func generateNextUUID() -> JSONRPCId {
        return .string(UUID().uuidString)
    }
    
    /// Generate a new unique JSONRPCId using NanoID with specified size (default is 5)
    public static func generateNextNanoId(size: Int = 5) -> JSONRPCId {
        return .string(NanoID.new(size))
    }
        
}
