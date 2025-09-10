// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rewardAccountSummary = try? newJSONDecoder().decode(RewardAccountSummary.self, from: jsonData)

import Foundation

// MARK: - RewardAccountSummary
public struct RewardAccountSummary: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let rewardAccountSummaryRequired: [String]
    public let properties: RewardAccountSummaryProperties
    public let examples: [RewardAccountSummaryExample]

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case rewardAccountSummaryRequired = "required"
        case properties, examples
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, rewardAccountSummaryRequired: [String], properties: RewardAccountSummaryProperties, examples: [RewardAccountSummaryExample]) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.rewardAccountSummaryRequired = rewardAccountSummaryRequired
        self.properties = properties
        self.examples = examples
    }
}
