// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let magentaData = try? newJSONDecoder().decode(MagentaData.self, from: jsonData)

import Foundation

// MARK: - MagentaData
public struct MagentaData: Codable, Sendable {
    public let type: MessageType?
    public let description, ref: String?

    public enum CodingKeys: String, CodingKey {
        case type, description
        case ref = "$ref"
    }

    public init(type: MessageType?, description: String?, ref: String?) {
        self.type = type
        self.description = description
        self.ref = ref
    }
}
