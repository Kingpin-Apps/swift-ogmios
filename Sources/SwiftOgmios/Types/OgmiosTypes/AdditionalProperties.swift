// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let additionalProperties = try? newJSONDecoder().decode(AdditionalProperties.self, from: jsonData)

import Foundation

// MARK: - AdditionalProperties
public struct AdditionalProperties: Codable, Sendable {
    public let type, description: String

    public init(type: String, description: String) {
        self.type = type
        self.description = description
    }
}
