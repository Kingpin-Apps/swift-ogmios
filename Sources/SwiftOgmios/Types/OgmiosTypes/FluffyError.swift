// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fluffyError = try? newJSONDecoder().decode(FluffyError.self, from: jsonData)

import Foundation

// MARK: - FluffyError
public struct FluffyError: Codable, Sendable {
    public let description: String
    public let type: DeserialisationFailureType
    public let errorRequired: [DeserialisationFailureRequired]
    public let additionalProperties: Bool
    public let properties: Properties16

    public enum CodingKeys: String, CodingKey {
        case description, type
        case errorRequired = "required"
        case additionalProperties, properties
    }

    public init(description: String, type: DeserialisationFailureType, errorRequired: [DeserialisationFailureRequired], additionalProperties: Bool, properties: Properties16) {
        self.description = description
        self.type = type
        self.errorRequired = errorRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
