// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailure = try? newJSONDecoder().decode(SubmitTransactionFailure.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailure
public struct SubmitTransactionFailure: Codable, Sendable {
    public let oneOf: [SubmitTransactionFailureOneOf]

    public init(oneOf: [SubmitTransactionFailureOneOf]) {
        self.oneOf = oneOf
    }
}
