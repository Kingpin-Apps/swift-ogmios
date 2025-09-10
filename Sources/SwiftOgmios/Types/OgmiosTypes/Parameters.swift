// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let parameters = try? newJSONDecoder().decode(Parameters.self, from: jsonData)

import Foundation

// MARK: - Parameters
public struct Parameters: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let description: String
    public let additionalProperties: Bool
    public let parametersRequired: [String]
    public let properties: ParametersProperties

    public enum CodingKeys: String, CodingKey {
        case type, description, additionalProperties
        case parametersRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, description: String, additionalProperties: Bool, parametersRequired: [String], properties: ParametersProperties) {
        self.type = type
        self.description = description
        self.additionalProperties = additionalProperties
        self.parametersRequired = parametersRequired
        self.properties = properties
    }
}
