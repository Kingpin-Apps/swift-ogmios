// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let evaluateTransactionResponse = try? newJSONDecoder().decode(EvaluateTransactionResponse.self, from: jsonData)

import Foundation

// MARK: - EvaluateTransactionResponse
public struct EvaluateTransactionResponse: Codable, Sendable {
    public let oneOf: [EvaluateTransactionResponseOneOf]

    public init(oneOf: [EvaluateTransactionResponseOneOf]) {
        self.oneOf = oneOf
    }
}
