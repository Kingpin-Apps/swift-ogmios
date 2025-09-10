// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stickyData = try? newJSONDecoder().decode(StickyData.self, from: jsonData)

import Foundation

// MARK: - StickyData
public struct StickyData: Codable, Sendable {
    public let ref: String?
    public let type: DeserialisationFailureType?
    public let additionalProperties: Bool?
    public let dataRequired: [String]?
    public let properties: MischievousProperties?
    public let oneOf: [DataOneOf]?
    public let error: Message?

    public enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case type, additionalProperties
        case dataRequired = "required"
        case properties, oneOf, error
    }

    public init(ref: String?, type: DeserialisationFailureType?, additionalProperties: Bool?, dataRequired: [String]?, properties: MischievousProperties?, oneOf: [DataOneOf]?, error: Message?) {
        self.ref = ref
        self.type = type
        self.additionalProperties = additionalProperties
        self.dataRequired = dataRequired
        self.properties = properties
        self.oneOf = oneOf
        self.error = error
    }
}
