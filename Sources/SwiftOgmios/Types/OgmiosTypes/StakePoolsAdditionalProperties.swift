// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stakePoolsAdditionalProperties = try? newJSONDecoder().decode(StakePoolsAdditionalProperties.self, from: jsonData)

import Foundation

// MARK: - StakePoolsAdditionalProperties
public struct StakePoolsAdditionalProperties: Codable, Sendable {
    public let title: String
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let additionalPropertiesRequired: [String]

    public enum CodingKeys: String, CodingKey {
        case title, type, additionalProperties
        case additionalPropertiesRequired = "required"
    }

    public init(title: String, type: DeserialisationFailureType, additionalProperties: Bool, additionalPropertiesRequired: [String]) {
        self.title = title
        self.type = type
        self.additionalProperties = additionalProperties
        self.additionalPropertiesRequired = additionalPropertiesRequired
    }
}
