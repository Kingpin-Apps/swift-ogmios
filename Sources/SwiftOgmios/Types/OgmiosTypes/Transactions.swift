// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transactions = try? newJSONDecoder().decode(Transactions.self, from: jsonData)

import Foundation

// MARK: - Transactions
public struct Transactions: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let transactionsRequired: [String]
    public let properties: TransactionsProperties

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case transactionsRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, transactionsRequired: [String], properties: TransactionsProperties) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.transactionsRequired = transactionsRequired
        self.properties = properties
    }
}
