// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let jsonrpc = try? newJSONDecoder().decode(Jsonrpc.self, from: jsonData)

import Foundation

// MARK: - Jsonrpc
public struct Jsonrpc: Codable, Sendable {
    public let type: MessageType
    public let jsonrpcEnum: [String]

    public enum CodingKeys: String, CodingKey {
        case type
        case jsonrpcEnum = "enum"
    }

    public init(type: MessageType, jsonrpcEnum: [String]) {
        self.type = type
        self.jsonrpcEnum = jsonrpcEnum
    }
}
