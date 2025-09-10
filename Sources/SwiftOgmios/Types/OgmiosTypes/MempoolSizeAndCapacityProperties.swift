// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mempoolSizeAndCapacityProperties = try? newJSONDecoder().decode(MempoolSizeAndCapacityProperties.self, from: jsonData)

import Foundation

// MARK: - MempoolSizeAndCapacityProperties
public struct MempoolSizeAndCapacityProperties: Codable, Sendable {
    public let maxCapacity, currentSize: PropertyNames
    public let transactions: Transactions

    public init(maxCapacity: PropertyNames, currentSize: PropertyNames, transactions: Transactions) {
        self.maxCapacity = maxCapacity
        self.currentSize = currentSize
        self.transactions = transactions
    }
}
