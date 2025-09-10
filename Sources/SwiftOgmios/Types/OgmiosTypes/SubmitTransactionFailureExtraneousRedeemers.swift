// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureExtraneousRedeemers = try? newJSONDecoder().decode(SubmitTransactionFailureExtraneousRedeemers.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureExtraneousRedeemers
public struct SubmitTransactionFailureExtraneousRedeemers: Codable, Sendable {
    public let title, description: String
    public let type: DeserialisationFailureType
    public let submitTransactionFailureExtraneousRedeemersRequired: [DeserialisationFailureRequired]
    public let additionalProperties: Bool
    public let properties: SubmitTransactionFailureExtraneousRedeemersProperties

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case submitTransactionFailureExtraneousRedeemersRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, description: String, type: DeserialisationFailureType, submitTransactionFailureExtraneousRedeemersRequired: [DeserialisationFailureRequired], additionalProperties: Bool, properties: SubmitTransactionFailureExtraneousRedeemersProperties) {
        self.title = title
        self.description = description
        self.type = type
        self.submitTransactionFailureExtraneousRedeemersRequired = submitTransactionFailureExtraneousRedeemersRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
