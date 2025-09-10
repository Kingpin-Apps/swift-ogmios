// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let queryLedgerStateConstitutionalCommitteeResponseOneOf = try? newJSONDecoder().decode(QueryLedgerStateConstitutionalCommitteeResponseOneOf.self, from: jsonData)

import Foundation

// MARK: - QueryLedgerStateConstitutionalCommitteeResponseOneOf
public struct QueryLedgerStateConstitutionalCommitteeResponseOneOf: Codable, Sendable {
    public let title: String?
    public let type: DeserialisationFailureType?
    public let oneOfRequired: [AcquireLedgerStateRequired]?
    public let additionalProperties: Bool?
    public let properties: AcquireLedgerStateProperties?
    public let ref: Ref?

    public enum CodingKeys: String, CodingKey {
        case title, type
        case oneOfRequired = "required"
        case additionalProperties, properties
        case ref = "$ref"
    }

    public init(title: String?, type: DeserialisationFailureType?, oneOfRequired: [AcquireLedgerStateRequired]?, additionalProperties: Bool?, properties: AcquireLedgerStateProperties?, ref: Ref?) {
        self.title = title
        self.type = type
        self.oneOfRequired = oneOfRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
        self.ref = ref
    }
}
