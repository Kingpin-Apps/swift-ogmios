// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureMissingCostModelsProperties = try? newJSONDecoder().decode(SubmitTransactionFailureMissingCostModelsProperties.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureMissingCostModelsProperties
public struct SubmitTransactionFailureMissingCostModelsProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: HilariousData

    public init(code: Code, message: Message, data: HilariousData) {
        self.code = code
        self.message = message
        self.data = data
    }
}
