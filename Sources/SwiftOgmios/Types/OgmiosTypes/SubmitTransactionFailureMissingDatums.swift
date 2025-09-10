// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureMissingDatums = try? newJSONDecoder().decode(SubmitTransactionFailureMissingDatums.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureMissingDatums
public struct SubmitTransactionFailureMissingDatums: Codable, Sendable {
    public let title, description: String
    public let type: DeserialisationFailureType
    public let submitTransactionFailureMissingDatumsRequired: [DeserialisationFailureRequired]
    public let additionalProperties: Bool
    public let properties: SubmitTransactionFailureMissingDatumsProperties

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case submitTransactionFailureMissingDatumsRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, description: String, type: DeserialisationFailureType, submitTransactionFailureMissingDatumsRequired: [DeserialisationFailureRequired], additionalProperties: Bool, properties: SubmitTransactionFailureMissingDatumsProperties) {
        self.title = title
        self.description = description
        self.type = type
        self.submitTransactionFailureMissingDatumsRequired = submitTransactionFailureMissingDatumsRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
