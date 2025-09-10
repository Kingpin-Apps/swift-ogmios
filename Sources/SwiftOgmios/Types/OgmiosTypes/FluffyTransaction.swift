// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fluffyTransaction = try? newJSONDecoder().decode(FluffyTransaction.self, from: jsonData)

import Foundation

// MARK: - FluffyTransaction
public struct FluffyTransaction: Codable, Sendable {
    public let anyOf: [StakePool]

    public init(anyOf: [StakePool]) {
        self.anyOf = anyOf
    }
}
