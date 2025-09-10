// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let evaluateTransactionFailureOneOf = try? newJSONDecoder().decode(EvaluateTransactionFailureOneOf.self, from: jsonData)

import Foundation

// MARK: - EvaluateTransactionFailureOneOf
public struct EvaluateTransactionFailureOneOf: Codable, Sendable {
    public let title, description: String
    public let type: DeserialisationFailureType
    public let oneOfRequired: [DeserialisationFailureRequired]
    public let additionalProperties: Bool
    public let properties: FluffyProperties

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case oneOfRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, description: String, type: DeserialisationFailureType, oneOfRequired: [DeserialisationFailureRequired], additionalProperties: Bool, properties: FluffyProperties) {
        self.title = title
        self.description = description
        self.type = type
        self.oneOfRequired = oneOfRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
