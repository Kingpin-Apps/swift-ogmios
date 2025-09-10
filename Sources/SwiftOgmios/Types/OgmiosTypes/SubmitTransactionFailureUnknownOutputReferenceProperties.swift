// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureUnknownOutputReferenceProperties = try? newJSONDecoder().decode(SubmitTransactionFailureUnknownOutputReferenceProperties.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureUnknownOutputReferenceProperties
public struct SubmitTransactionFailureUnknownOutputReferenceProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: CunningData

    public init(code: Code, message: Message, data: CunningData) {
        self.code = code
        self.message = message
        self.data = data
    }
}
