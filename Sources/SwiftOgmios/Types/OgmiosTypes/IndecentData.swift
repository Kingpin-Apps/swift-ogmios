// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let indecentData = try? newJSONDecoder().decode(IndecentData.self, from: jsonData)

import Foundation

// MARK: - IndecentData
public struct IndecentData: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let dataRequired: [String]
    public let properties: Properties4

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case dataRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, dataRequired: [String], properties: Properties4) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.dataRequired = dataRequired
        self.properties = properties
    }
}
