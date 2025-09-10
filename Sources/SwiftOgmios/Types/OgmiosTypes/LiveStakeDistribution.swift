// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let liveStakeDistribution = try? newJSONDecoder().decode(LiveStakeDistribution.self, from: jsonData)

import Foundation

// MARK: - LiveStakeDistribution
public struct LiveStakeDistribution: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let description: String
    public let propertyNames: PropertyNames
    public let additionalProperties: LiveStakeDistributionAdditionalProperties
    public let examples: [[String: ExampleValue]]

    public init(type: DeserialisationFailureType, description: String, propertyNames: PropertyNames, additionalProperties: LiveStakeDistributionAdditionalProperties, examples: [[String: ExampleValue]]) {
        self.type = type
        self.description = description
        self.propertyNames = propertyNames
        self.additionalProperties = additionalProperties
        self.examples = examples
    }
}
