// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eraMismatch = try? newJSONDecoder().decode(EraMismatch.self, from: jsonData)

import Foundation

// MARK: - EraMismatch
public struct EraMismatch: Codable, Sendable {
    public let title: String
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let eraMismatchRequired: [String]
    public let properties: EraMismatchProperties

    public enum CodingKeys: String, CodingKey {
        case title, type, additionalProperties
        case eraMismatchRequired = "required"
        case properties
    }

    public init(title: String, type: DeserialisationFailureType, additionalProperties: Bool, eraMismatchRequired: [String], properties: EraMismatchProperties) {
        self.title = title
        self.type = type
        self.additionalProperties = additionalProperties
        self.eraMismatchRequired = eraMismatchRequired
        self.properties = properties
    }
}
