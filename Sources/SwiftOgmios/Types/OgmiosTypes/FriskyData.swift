// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let friskyData = try? newJSONDecoder().decode(FriskyData.self, from: jsonData)

import Foundation

// MARK: - FriskyData
public struct FriskyData: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let dataRequired: [String]
    public let properties: Properties17

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case dataRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, dataRequired: [String], properties: Properties17) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.dataRequired = dataRequired
        self.properties = properties
    }
}
