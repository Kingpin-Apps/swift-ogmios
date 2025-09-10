// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureExecutionBudgetOutOfBounds = try? newJSONDecoder().decode(SubmitTransactionFailureExecutionBudgetOutOfBounds.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureExecutionBudgetOutOfBounds
public struct SubmitTransactionFailureExecutionBudgetOutOfBounds: Codable, Sendable {
    public let title, description: String
    public let type: DeserialisationFailureType
    public let submitTransactionFailureExecutionBudgetOutOfBoundsRequired: [DeserialisationFailureRequired]
    public let additionalProperties: Bool
    public let properties: SubmitTransactionFailureExecutionBudgetOutOfBoundsProperties

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case submitTransactionFailureExecutionBudgetOutOfBoundsRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, description: String, type: DeserialisationFailureType, submitTransactionFailureExecutionBudgetOutOfBoundsRequired: [DeserialisationFailureRequired], additionalProperties: Bool, properties: SubmitTransactionFailureExecutionBudgetOutOfBoundsProperties) {
        self.title = title
        self.description = description
        self.type = type
        self.submitTransactionFailureExecutionBudgetOutOfBoundsRequired = submitTransactionFailureExecutionBudgetOutOfBoundsRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
