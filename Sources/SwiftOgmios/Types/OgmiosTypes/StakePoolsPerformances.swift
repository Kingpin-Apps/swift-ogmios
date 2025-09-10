// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stakePoolsPerformances = try? newJSONDecoder().decode(StakePoolsPerformances.self, from: jsonData)

import Foundation

// MARK: - StakePoolsPerformances
public struct StakePoolsPerformances: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let description: String
    public let additionalProperties: Bool
    public let stakePoolsPerformancesRequired: [String]
    public let properties: StakePoolsPerformancesProperties

    public enum CodingKeys: String, CodingKey {
        case type, description, additionalProperties
        case stakePoolsPerformancesRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, description: String, additionalProperties: Bool, stakePoolsPerformancesRequired: [String], properties: StakePoolsPerformancesProperties) {
        self.type = type
        self.description = description
        self.additionalProperties = additionalProperties
        self.stakePoolsPerformancesRequired = stakePoolsPerformancesRequired
        self.properties = properties
    }
}
