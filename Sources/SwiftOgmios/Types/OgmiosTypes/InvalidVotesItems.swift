// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let invalidVotesItems = try? newJSONDecoder().decode(InvalidVotesItems.self, from: jsonData)

import Foundation

// MARK: - InvalidVotesItems
public struct InvalidVotesItems: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let itemsRequired: [String]
    public let properties: Properties2

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case itemsRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, itemsRequired: [String], properties: Properties2) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.itemsRequired = itemsRequired
        self.properties = properties
    }
}
