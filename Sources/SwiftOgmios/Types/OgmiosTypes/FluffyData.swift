// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fluffyData = try? newJSONDecoder().decode(FluffyData.self, from: jsonData)

import Foundation

// MARK: - FluffyData
public struct FluffyData: Codable, Sendable {
    public let description: String?
    public let type: String
    public let additionalProperties: Bool?
    public let dataRequired: [String]?
    public let properties: StickyProperties?
    public let items: DataItems?

    public enum CodingKeys: String, CodingKey {
        case description, type, additionalProperties
        case dataRequired = "required"
        case properties, items
    }

    public init(description: String?, type: String, additionalProperties: Bool?, dataRequired: [String]?, properties: StickyProperties?, items: DataItems?) {
        self.description = description
        self.type = type
        self.additionalProperties = additionalProperties
        self.dataRequired = dataRequired
        self.properties = properties
        self.items = items
    }
}
