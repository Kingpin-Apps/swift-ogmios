// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let acquireLedgerState = try? newJSONDecoder().decode(AcquireLedgerState.self, from: jsonData)

import Foundation

// MARK: - AcquireLedgerState
public struct AcquireLedgerState: Codable, Sendable {
    public let title: String
    public let type: DeserialisationFailureType
    public let description: String
    public let acquireLedgerStateRequired: [AcquireLedgerStateRequired]
    public let additionalProperties: Bool
    public let properties: AcquireLedgerStateProperties

    public enum CodingKeys: String, CodingKey {
        case title, type, description
        case acquireLedgerStateRequired = "required"
        case additionalProperties, properties
    }

    public init(title: String, type: DeserialisationFailureType, description: String, acquireLedgerStateRequired: [AcquireLedgerStateRequired], additionalProperties: Bool, properties: AcquireLedgerStateProperties) {
        self.title = title
        self.type = type
        self.description = description
        self.acquireLedgerStateRequired = acquireLedgerStateRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
    }
}
