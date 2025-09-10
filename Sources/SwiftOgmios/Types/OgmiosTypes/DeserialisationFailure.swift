// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let deserialisationFailure = try? newJSONDecoder().decode(DeserialisationFailure.self, from: jsonData)

import Foundation

// MARK: - DeserialisationFailure
public struct DeserialisationFailure: Codable, Sendable {
    public let title, description: String
    public let type: DeserialisationFailureType
    public let deserialisationFailureRequired: [DeserialisationFailureRequired]
    public let additionalProperties: Bool
    public let properties: DeserialisationFailureProperties

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case deserialisationFailureRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, description: String, type: DeserialisationFailureType, deserialisationFailureRequired: [DeserialisationFailureRequired], additionalProperties: Bool, properties: DeserialisationFailureProperties) {
        self.title = title
        self.description = description
        self.type = type
        self.deserialisationFailureRequired = deserialisationFailureRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
