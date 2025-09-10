// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionResponse = try? newJSONDecoder().decode(SubmitTransactionResponse.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionResponse
public struct SubmitTransactionResponse: Codable, Sendable {
    public let oneOf: [SubmitTransactionResponseOneOf]

    public init(oneOf: [SubmitTransactionResponseOneOf]) {
        self.oneOf = oneOf
    }
}
