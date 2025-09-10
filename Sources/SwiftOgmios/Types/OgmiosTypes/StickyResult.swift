// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stickyResult = try? newJSONDecoder().decode(StickyResult.self, from: jsonData)

import Foundation

// MARK: - StickyResult
public struct StickyResult: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let resultRequired: [String]
    public let properties: Properties21

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case resultRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, resultRequired: [String], properties: Properties21) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.resultRequired = resultRequired
        self.properties = properties
    }
}
