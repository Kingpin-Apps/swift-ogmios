// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nonces = try? newJSONDecoder().decode(Nonces.self, from: jsonData)

import Foundation

// MARK: - Nonces
public struct Nonces: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let description: String
    public let additionalProperties: Bool
    public let noncesRequired: [String]
    public let properties: NoncesProperties

    public enum CodingKeys: String, CodingKey {
        case type, description, additionalProperties
        case noncesRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, description: String, additionalProperties: Bool, noncesRequired: [String], properties: NoncesProperties) {
        self.type = type
        self.description = description
        self.additionalProperties = additionalProperties
        self.noncesRequired = noncesRequired
        self.properties = properties
    }
}
