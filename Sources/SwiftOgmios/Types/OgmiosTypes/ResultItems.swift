// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let resultItems = try? newJSONDecoder().decode(ResultItems.self, from: jsonData)

import Foundation

// MARK: - ResultItems
public struct ResultItems: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let itemsRequired: [String]
    public let properties: Properties14

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case itemsRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, itemsRequired: [String], properties: Properties14) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.itemsRequired = itemsRequired
        self.properties = properties
    }
}
