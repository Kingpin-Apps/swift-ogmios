// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transactionsProperties = try? newJSONDecoder().decode(TransactionsProperties.self, from: jsonData)

import Foundation

// MARK: - TransactionsProperties
public struct TransactionsProperties: Codable, Sendable {
    public let count: PropertyNames

    public init(count: PropertyNames) {
        self.count = count
    }
}
