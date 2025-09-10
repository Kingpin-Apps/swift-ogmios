// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureUnknownOutputReference = try? newJSONDecoder().decode(SubmitTransactionFailureUnknownOutputReference.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureUnknownOutputReference
public struct SubmitTransactionFailureUnknownOutputReference: Codable, Sendable {
    public let title, description: String
    public let type: DeserialisationFailureType
    public let submitTransactionFailureUnknownOutputReferenceRequired: [DeserialisationFailureRequired]
    public let additionalProperties: Bool
    public let properties: SubmitTransactionFailureUnknownOutputReferenceProperties

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case submitTransactionFailureUnknownOutputReferenceRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, description: String, type: DeserialisationFailureType, submitTransactionFailureUnknownOutputReferenceRequired: [DeserialisationFailureRequired], additionalProperties: Bool, properties: SubmitTransactionFailureUnknownOutputReferenceProperties) {
        self.title = title
        self.description = description
        self.type = type
        self.submitTransactionFailureUnknownOutputReferenceRequired = submitTransactionFailureUnknownOutputReferenceRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
