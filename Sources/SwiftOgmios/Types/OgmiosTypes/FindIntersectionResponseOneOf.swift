// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let findIntersectionResponseOneOf = try? newJSONDecoder().decode(FindIntersectionResponseOneOf.self, from: jsonData)

import Foundation

// MARK: - FindIntersectionResponseOneOf
public struct FindIntersectionResponseOneOf: Codable, Sendable {
    public let title: String
    public let type: DeserialisationFailureType
    public let oneOfRequired: [AcquireLedgerStateRequired]
    public let additionalProperties: Bool
    public let properties: Properties15

    public enum CodingKeys: String, CodingKey {
        case title, type
        case oneOfRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, type: DeserialisationFailureType, oneOfRequired: [AcquireLedgerStateRequired], additionalProperties: Bool, properties: Properties15) {
        self.title = title
        self.type = type
        self.oneOfRequired = oneOfRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
