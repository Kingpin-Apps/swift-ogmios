// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let params = try? newJSONDecoder().decode(Params.self, from: jsonData)

import Foundation

// MARK: - Params
public struct Params: Codable, Sendable {
    public let type: DeserialisationFailureType?
    public let additionalProperties: Bool?
    public let paramsRequired: [String]?
    public let properties: ParamsProperties?
    public let oneOf: [ParamsOneOf]?

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case paramsRequired = "required"
        case properties, oneOf
    }

    public init(type: DeserialisationFailureType?, additionalProperties: Bool?, paramsRequired: [String]?, properties: ParamsProperties?, oneOf: [ParamsOneOf]?) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.paramsRequired = paramsRequired
        self.properties = properties
        self.oneOf = oneOf
    }
}
