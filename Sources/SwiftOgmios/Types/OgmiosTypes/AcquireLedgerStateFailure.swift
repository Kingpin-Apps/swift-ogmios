// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let acquireLedgerStateFailure = try? newJSONDecoder().decode(AcquireLedgerStateFailure.self, from: jsonData)

import Foundation

// MARK: - AcquireLedgerStateFailure
public struct AcquireLedgerStateFailure: Codable, Sendable {
    public let title: String
    public let type: DeserialisationFailureType
    public let acquireLedgerStateFailureRequired: [AcquireLedgerStateRequired]
    public let additionalProperties: Bool
    public let properties: AcquireLedgerStateProperties

    public enum CodingKeys: String, CodingKey {
        case title, type
        case acquireLedgerStateFailureRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, type: DeserialisationFailureType, acquireLedgerStateFailureRequired: [AcquireLedgerStateRequired], additionalProperties: Bool, properties: AcquireLedgerStateProperties) {
        self.title = title
        self.type = type
        self.acquireLedgerStateFailureRequired = acquireLedgerStateFailureRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
