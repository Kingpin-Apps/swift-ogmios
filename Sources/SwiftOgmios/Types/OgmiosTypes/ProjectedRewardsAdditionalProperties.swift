// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectedRewardsAdditionalProperties = try? newJSONDecoder().decode(ProjectedRewardsAdditionalProperties.self, from: jsonData)

import Foundation

// MARK: - ProjectedRewardsAdditionalProperties
public struct ProjectedRewardsAdditionalProperties: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let propertyNames: AdditionalPropertiesPropertyNames
    public let additionalProperties: PropertyNames

    public init(type: DeserialisationFailureType, propertyNames: AdditionalPropertiesPropertyNames, additionalProperties: PropertyNames) {
        self.type = type
        self.propertyNames = propertyNames
        self.additionalProperties = additionalProperties
    }
}
