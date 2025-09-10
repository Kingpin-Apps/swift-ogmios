// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pointOrOriginOneOf = try? newJSONDecoder().decode(PointOrOriginOneOf.self, from: jsonData)

import Foundation

// MARK: - PointOrOriginOneOf
public struct PointOrOriginOneOf: Codable, Sendable {
    public let type: DeserialisationFailureType?
    public let description, title, name: String?
    public let additionalProperties: Bool?
    public let oneOfRequired: [String]?
    public let properties: IndecentProperties?
    public let ref: String?

    public enum CodingKeys: String, CodingKey {
        case type, description, title, name, additionalProperties
        case oneOfRequired = "required"
        case properties
        case ref = "$ref"
    }

    public init(type: DeserialisationFailureType?, description: String?, title: String?, name: String?, additionalProperties: Bool?, oneOfRequired: [String]?, properties: IndecentProperties?, ref: String?) {
        self.type = type
        self.description = description
        self.title = title
        self.name = name
        self.additionalProperties = additionalProperties
        self.oneOfRequired = oneOfRequired
        self.properties = properties
        self.ref = ref
    }
}
