// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let deposit = try? newJSONDecoder().decode(Deposit.self, from: jsonData)

import Foundation

// MARK: - Deposit
public struct Deposit: Codable, Sendable {
    public let ada: Ada

    public init(ada: Ada) {
        self.ada = ada
    }
}
