// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitTransactionFailureOneOf = try? newJSONDecoder().decode(SubmitTransactionFailureOneOf.self, from: jsonData)

import Foundation

// MARK: - SubmitTransactionFailureOneOf
public struct SubmitTransactionFailureOneOf: Codable, Sendable {
    public let title, description: String?
    public let type: DeserialisationFailureType?
    public let oneOfRequired: [DeserialisationFailureRequired]?
    public let additionalProperties: Bool?
    public let properties: MagentaProperties?
    public let ref: String?

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case oneOfRequired = "required"
        case additionalProperties, properties
        case ref = "$ref"
    }

    public init(title: String?, description: String?, type: DeserialisationFailureType?, oneOfRequired: [DeserialisationFailureRequired]?, additionalProperties: Bool?, properties: MagentaProperties?, ref: String?) {
        self.title = title
        self.description = description
        self.type = type
        self.oneOfRequired = oneOfRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
        self.ref = ref
    }
}
