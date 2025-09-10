// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let evaluateTransactionFailure = try? newJSONDecoder().decode(EvaluateTransactionFailure.self, from: jsonData)

import Foundation

// MARK: - EvaluateTransactionFailure
public struct EvaluateTransactionFailure: Codable, Sendable {
    public let oneOf: [EvaluateTransactionFailureOneOf]

    public init(oneOf: [EvaluateTransactionFailureOneOf]) {
        self.oneOf = oneOf
    }
}
