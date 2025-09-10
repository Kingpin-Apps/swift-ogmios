// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let computed = try? newJSONDecoder().decode(Computed.self, from: jsonData)

import Foundation

// MARK: - Computed
public struct Computed: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let computedRequired: [String]
    public let properties: ComputedProperties

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case computedRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, computedRequired: [String], properties: ComputedProperties) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.computedRequired = computedRequired
        self.properties = properties
    }
}
