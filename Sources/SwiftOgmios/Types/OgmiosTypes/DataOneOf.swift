// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dataOneOf = try? newJSONDecoder().decode(DataOneOf.self, from: jsonData)

import Foundation

// MARK: - DataOneOf
public struct DataOneOf: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let oneOfRequired: [PurpleRequired]
    public let properties: FriskyProperties

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case oneOfRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, oneOfRequired: [PurpleRequired], properties: FriskyProperties) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.oneOfRequired = oneOfRequired
        self.properties = properties
    }
}
