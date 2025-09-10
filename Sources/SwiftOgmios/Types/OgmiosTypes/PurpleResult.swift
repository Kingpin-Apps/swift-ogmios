// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleResult = try? newJSONDecoder().decode(PurpleResult.self, from: jsonData)

import Foundation

// MARK: - PurpleResult
public struct PurpleResult: Codable, Sendable {
    public let type: String?
    public let additionalProperties: AdditionalPropertiesUnion?
    public let resultRequired: [String]?
    public let properties: Properties12?
    public let oneOf: [ResultOneOf]?
    public let description, ref: String?
    public let items: PropertyNames?
    public let title: String?
    public let propertyNames: PropertyNames?

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case resultRequired = "required"
        case properties, oneOf, description
        case ref = "$ref"
        case items, title, propertyNames
    }

    public init(type: String?, additionalProperties: AdditionalPropertiesUnion?, resultRequired: [String]?, properties: Properties12?, oneOf: [ResultOneOf]?, description: String?, ref: String?, items: PropertyNames?, title: String?, propertyNames: PropertyNames?) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.resultRequired = resultRequired
        self.properties = properties
        self.oneOf = oneOf
        self.description = description
        self.ref = ref
        self.items = items
        self.title = title
        self.propertyNames = propertyNames
    }
}
