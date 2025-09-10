// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rewardsProvenance = try? newJSONDecoder().decode(RewardsProvenance.self, from: jsonData)

import Foundation

// MARK: - RewardsProvenance
public struct RewardsProvenance: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let rewardsProvenanceRequired: [String]
    public let properties: RewardsProvenanceProperties

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case rewardsProvenanceRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, rewardsProvenanceRequired: [String], properties: RewardsProvenanceProperties) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.rewardsProvenanceRequired = rewardsProvenanceRequired
        self.properties = properties
    }
}
