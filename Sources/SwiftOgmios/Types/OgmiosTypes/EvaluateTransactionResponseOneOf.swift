// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let evaluateTransactionResponseOneOf = try? newJSONDecoder().decode(EvaluateTransactionResponseOneOf.self, from: jsonData)

import Foundation

// MARK: - EvaluateTransactionResponseOneOf
public struct EvaluateTransactionResponseOneOf: Codable, Sendable {
    public let title: String
    public let type: DeserialisationFailureType
    public let oneOfRequired: [AcquireLedgerStateRequired]
    public let additionalProperties: Bool
    public let properties: Properties13
    public let examples: [OneOfExample]?
    public let description: String?

    public enum CodingKeys: String, CodingKey {
        case title, type
        case oneOfRequired = "required"
        case additionalProperties, properties, examples, description
    }

    public init(title: String, type: DeserialisationFailureType, oneOfRequired: [AcquireLedgerStateRequired], additionalProperties: Bool, properties: Properties13, examples: [OneOfExample]?, description: String?) {
        self.title = title
        self.type = type
        self.oneOfRequired = oneOfRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
        self.examples = examples
        self.description = description
    }
}
