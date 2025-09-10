// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let resultOneOf = try? newJSONDecoder().decode(ResultOneOf.self, from: jsonData)

import Foundation

// MARK: - ResultOneOf
public struct ResultOneOf: Codable, Sendable {
    public let title: String?
    public let oneOfRequired: [String]?
    public let type: String?
    public let additionalProperties: Bool?
    public let properties: Properties11?
    public let ref: String?
    public let oneOf: [PropertyNames]?

    public enum CodingKeys: String, CodingKey {
        case title
        case oneOfRequired = "required"
        case type, additionalProperties, properties
        case ref = "$ref"
        case oneOf
    }

    public init(title: String?, oneOfRequired: [String]?, type: String?, additionalProperties: Bool?, properties: Properties11?, ref: String?, oneOf: [PropertyNames]?) {
        self.title = title
        self.oneOfRequired = oneOfRequired
        self.type = type
        self.additionalProperties = additionalProperties
        self.properties = properties
        self.ref = ref
        self.oneOf = oneOf
    }
}
