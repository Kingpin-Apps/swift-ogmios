import Foundation
import Network
import PotentCodables

// MARK: - JSON-RPC Protocol Structures
public protocol JSONSerializable: Codable, CustomDebugStringConvertible, CustomStringConvertible {}
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

/// JSON-RPC 2.0 Request
public protocol JSONRPCRequest: JSONSerializable {
    associatedtype T: Codable
    
    var jsonrpc: String { get }
    var method: String { get }
    var params: T? { get }
    var id: JSONRPCId? { get }
}

/// JSON-RPC 2.0 Response
public protocol JSONRPCResponse: JSONSerializable {
    associatedtype T: Codable
    
    var jsonrpc: String { get }
    var method: String { get }
    var result: T { get }
    var id: JSONRPCId? { get }
}

public protocol JSONRPCResponseError: JSONSerializable {
    associatedtype T: JSONRPCError
    
    var jsonrpc: String { get }
    var method: String { get }
    var error: T? { get }
    var id: JSONRPCId? { get }
}

/// JSON-RPC 2.0 Error
public protocol JSONRPCError: JSONSerializable, Hashable, Sendable {
    var code: Int { get }
    var message: String { get }
}

/// JSON-RPC ID can be string, number, or null
public enum JSONRPCId: JSONSerializable, Hashable, Sendable {
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
}
