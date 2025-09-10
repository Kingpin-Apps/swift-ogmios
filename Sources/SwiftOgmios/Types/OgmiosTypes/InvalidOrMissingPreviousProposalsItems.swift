// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let invalidOrMissingPreviousProposalsItems = try? newJSONDecoder().decode(InvalidOrMissingPreviousProposalsItems.self, from: jsonData)

import Foundation

// MARK: - InvalidOrMissingPreviousProposalsItems
public struct InvalidOrMissingPreviousProposalsItems: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let itemsRequired: [String]
    public let additionalProperties: Bool
    public let properties: Properties1

    public enum CodingKeys: String, CodingKey {
        case type
        case itemsRequired = "required"
        case additionalProperties, properties
    }

    public init(type: DeserialisationFailureType, itemsRequired: [String], additionalProperties: Bool, properties: Properties1) {
        self.type = type
        self.itemsRequired = itemsRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
