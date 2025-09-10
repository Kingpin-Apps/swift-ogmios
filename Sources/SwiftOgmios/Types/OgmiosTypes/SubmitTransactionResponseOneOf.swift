// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionResponseOneOf = try? newJSONDecoder().decode(SubmitTransactionResponseOneOf.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionResponseOneOf
public struct SubmitTransactionResponseOneOf: Codable, Sendable {
    public let title: String
    public let type: DeserialisationFailureType
    public let oneOfRequired: [AcquireLedgerStateRequired]
    public let additionalProperties: Bool
    public let properties: Properties20

    public enum CodingKeys: String, CodingKey {
        case title, type
        case oneOfRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, type: DeserialisationFailureType, oneOfRequired: [AcquireLedgerStateRequired], additionalProperties: Bool, properties: Properties20) {
        self.title = title
        self.type = type
        self.oneOfRequired = oneOfRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
