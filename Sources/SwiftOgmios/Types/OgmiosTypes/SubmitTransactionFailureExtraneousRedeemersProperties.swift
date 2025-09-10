// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureExtraneousRedeemersProperties = try? newJSONDecoder().decode(SubmitTransactionFailureExtraneousRedeemersProperties.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureExtraneousRedeemersProperties
public struct SubmitTransactionFailureExtraneousRedeemersProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: IndecentData

    public init(code: Code, message: Message, data: IndecentData) {
        self.code = code
        self.message = message
        self.data = data
    }
}
