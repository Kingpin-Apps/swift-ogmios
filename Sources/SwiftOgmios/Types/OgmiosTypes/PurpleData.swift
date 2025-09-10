// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleData = try? newJSONDecoder().decode(PurpleData.self, from: jsonData)

import Foundation

// MARK: - PurpleData
public struct PurpleData: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let dataRequired: [String]
    public let additionalProperties: Bool
    public let properties: PurpleProperties

    public enum CodingKeys: String, CodingKey {
        case type
        case dataRequired = "required"
        case additionalProperties, properties
    }

    public init(type: DeserialisationFailureType, dataRequired: [String], additionalProperties: Bool, properties: PurpleProperties) {
        self.type = type
        self.dataRequired = dataRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
