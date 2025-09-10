// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureMissingCostModels = try? newJSONDecoder().decode(SubmitTransactionFailureMissingCostModels.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureMissingCostModels
public struct SubmitTransactionFailureMissingCostModels: Codable, Sendable {
    public let title, description: String
    public let type: DeserialisationFailureType
    public let submitTransactionFailureMissingCostModelsRequired: [DeserialisationFailureRequired]
    public let additionalProperties: Bool
    public let properties: SubmitTransactionFailureMissingCostModelsProperties

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case submitTransactionFailureMissingCostModelsRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, description: String, type: DeserialisationFailureType, submitTransactionFailureMissingCostModelsRequired: [DeserialisationFailureRequired], additionalProperties: Bool, properties: SubmitTransactionFailureMissingCostModelsProperties) {
        self.title = title
        self.description = description
        self.type = type
        self.submitTransactionFailureMissingCostModelsRequired = submitTransactionFailureMissingCostModelsRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
