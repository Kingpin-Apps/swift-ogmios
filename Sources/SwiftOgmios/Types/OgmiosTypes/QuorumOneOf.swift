// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quorumOneOf = try? newJSONDecoder().decode(QuorumOneOf.self, from: jsonData)

import Foundation

// MARK: - QuorumOneOf
public struct QuorumOneOf: Codable, Sendable {
    public let type: MessageType?
    public let ref: String?

    public enum CodingKeys: String, CodingKey {
        case type
        case ref = "$ref"
    }

    public init(type: MessageType?, ref: String?) {
        self.type = type
        self.ref = ref
    }
}
