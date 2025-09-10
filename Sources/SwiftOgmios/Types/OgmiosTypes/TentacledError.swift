// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tentacledError = try? newJSONDecoder().decode(TentacledError.self, from: jsonData)

import Foundation

// MARK: - TentacledError
public struct TentacledError: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let errorRequired: [String]
    public let additionalProperties: Bool
    public let properties: Properties19

    public enum CodingKeys: String, CodingKey {
        case type
        case errorRequired = "required"
        case additionalProperties, properties
    }

    public init(type: DeserialisationFailureType, errorRequired: [String], additionalProperties: Bool, properties: Properties19) {
        self.type = type
        self.errorRequired = errorRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
