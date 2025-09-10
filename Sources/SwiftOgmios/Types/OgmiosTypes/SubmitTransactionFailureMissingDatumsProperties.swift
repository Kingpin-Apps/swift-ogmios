// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureMissingDatumsProperties = try? newJSONDecoder().decode(SubmitTransactionFailureMissingDatumsProperties.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureMissingDatumsProperties
public struct SubmitTransactionFailureMissingDatumsProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: AmbitiousData

    public init(code: Code, message: Message, data: AmbitiousData) {
        self.code = code
        self.message = message
        self.data = data
    }
}
