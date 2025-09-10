// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stakePoolSummary = try? newJSONDecoder().decode(StakePoolSummary.self, from: jsonData)

import Foundation

// MARK: - StakePoolSummary
public struct StakePoolSummary: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let stakePoolSummaryRequired: [String]
    public let properties: StakePoolSummaryProperties

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case stakePoolSummaryRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, stakePoolSummaryRequired: [String], properties: StakePoolSummaryProperties) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.stakePoolSummaryRequired = stakePoolSummaryRequired
        self.properties = properties
    }
}
