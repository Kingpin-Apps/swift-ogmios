// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let scriptExecutionFailureOneOf = try? newJSONDecoder().decode(ScriptExecutionFailureOneOf.self, from: jsonData)

import Foundation

// MARK: - ScriptExecutionFailureOneOf
public struct ScriptExecutionFailureOneOf: Codable, Sendable {
    public let title, description: String?
    public let type: DeserialisationFailureType?
    public let additionalProperties: Bool?
    public let oneOfRequired: [DeserialisationFailureRequired]?
    public let properties: AmbitiousProperties?
    public let ref: String?

    public enum CodingKeys: String, CodingKey {
        case title, description, type, additionalProperties
        case oneOfRequired = "required"
        case properties
        case ref = "$ref"
    }

    public init(title: String?, description: String?, type: DeserialisationFailureType?, additionalProperties: Bool?, oneOfRequired: [DeserialisationFailureRequired]?, properties: AmbitiousProperties?, ref: String?) {
        self.title = title
        self.description = description
        self.type = type
        self.additionalProperties = additionalProperties
        self.oneOfRequired = oneOfRequired
        self.properties = properties
        self.ref = ref
    }
}
