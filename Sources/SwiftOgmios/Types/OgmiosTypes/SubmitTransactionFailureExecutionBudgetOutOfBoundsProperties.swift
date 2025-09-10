// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureExecutionBudgetOutOfBoundsProperties = try? newJSONDecoder().decode(SubmitTransactionFailureExecutionBudgetOutOfBoundsProperties.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureExecutionBudgetOutOfBoundsProperties
public struct SubmitTransactionFailureExecutionBudgetOutOfBoundsProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: IndigoData

    public init(code: Code, message: Message, data: IndigoData) {
        self.code = code
        self.message = message
        self.data = data
    }
}
