// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties21 = try? newJSONDecoder().decode(Properties21.self, from: jsonData)

import Foundation

// MARK: - Properties21
public struct Properties21: Codable, Sendable {
    public let transaction: StakePool

    public init(transaction: StakePool) {
        self.transaction = transaction
    }
}
