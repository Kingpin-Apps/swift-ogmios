// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleError = try? newJSONDecoder().decode(PurpleError.self, from: jsonData)

import Foundation

// MARK: - PurpleError
public struct PurpleError: Codable, Sendable {
    public let description: String
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let errorRequired: [DeserialisationFailureRequired]
    public let properties: Properties8

    public enum CodingKeys: String, CodingKey {
        case description, type, additionalProperties
        case errorRequired = "required"
        case properties
    }

    public init(description: String, type: DeserialisationFailureType, additionalProperties: Bool, errorRequired: [DeserialisationFailureRequired], properties: Properties8) {
        self.description = description
        self.type = type
        self.additionalProperties = additionalProperties
        self.errorRequired = errorRequired
        self.properties = properties
    }
}
