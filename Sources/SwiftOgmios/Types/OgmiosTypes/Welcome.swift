// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
public struct Welcome: Codable, Sendable {
    public let schema: String
    public let id, title: String
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let welcomeRequired: [String]
    public let properties: WelcomeProperties
    public let definitions: Definitions

    public enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case id = "$id"
        case title, type, additionalProperties
        case welcomeRequired = "required"
        case properties, definitions
    }

    public init(schema: String, id: String, title: String, type: DeserialisationFailureType, additionalProperties: Bool, welcomeRequired: [String], properties: WelcomeProperties, definitions: Definitions) {
        self.schema = schema
        self.id = id
        self.title = title
        self.type = type
        self.additionalProperties = additionalProperties
        self.welcomeRequired = welcomeRequired
        self.properties = properties
        self.definitions = definitions
    }
}
