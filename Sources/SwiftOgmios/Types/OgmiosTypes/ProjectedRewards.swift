// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectedRewards = try? newJSONDecoder().decode(ProjectedRewards.self, from: jsonData)

import Foundation

// MARK: - ProjectedRewards
public struct ProjectedRewards: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let description: String
    public let propertyNames: ProjectedRewardsPropertyNames
    public let additionalProperties: ProjectedRewardsAdditionalProperties
    public let examples: [[String: [String: Deposit]]]

    public init(type: DeserialisationFailureType, description: String, propertyNames: ProjectedRewardsPropertyNames, additionalProperties: ProjectedRewardsAdditionalProperties, examples: [[String: [String: Deposit]]]) {
        self.type = type
        self.description = description
        self.propertyNames = propertyNames
        self.additionalProperties = additionalProperties
        self.examples = examples
    }
}
