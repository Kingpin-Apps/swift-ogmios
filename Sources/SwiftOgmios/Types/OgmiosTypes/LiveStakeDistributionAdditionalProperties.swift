// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let liveStakeDistributionAdditionalProperties = try? newJSONDecoder().decode(LiveStakeDistributionAdditionalProperties.self, from: jsonData)

import Foundation

// MARK: - LiveStakeDistributionAdditionalProperties
public struct LiveStakeDistributionAdditionalProperties: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let additionalPropertiesRequired: [String]
    public let properties: IndigoProperties

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case additionalPropertiesRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, additionalPropertiesRequired: [String], properties: IndigoProperties) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.additionalPropertiesRequired = additionalPropertiesRequired
        self.properties = properties
    }
}
