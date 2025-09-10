// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleTransaction = try? newJSONDecoder().decode(PurpleTransaction.self, from: jsonData)

import Foundation

// MARK: - PurpleTransaction
public struct PurpleTransaction: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let transactionRequired: [String]
    public let properties: Properties10

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case transactionRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, transactionRequired: [String], properties: Properties10) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.transactionRequired = transactionRequired
        self.properties = properties
    }
}
