// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let queryNetworkStartTimeResponse = try? newJSONDecoder().decode(QueryNetworkStartTimeResponse.self, from: jsonData)

import Foundation

// MARK: - QueryNetworkStartTimeResponse
public struct QueryNetworkStartTimeResponse: Codable, Sendable {
    public let title: String?
    public let type: DeserialisationFailureType?
    public let description: String?
    public let queryNetworkStartTimeResponseRequired: [AcquireLedgerStateRequired]?
    public let additionalProperties: Bool?
    public let properties: AcquireLedgerStateProperties?
    public let ref: Ref?

    public enum CodingKeys: String, CodingKey {
        case title, type, description
        case queryNetworkStartTimeResponseRequired = "required"
        case additionalProperties, properties
        case ref = "$ref"
    }

    public init(title: String?, type: DeserialisationFailureType?, description: String?, queryNetworkStartTimeResponseRequired: [AcquireLedgerStateRequired]?, additionalProperties: Bool?, properties: AcquireLedgerStateProperties?, ref: Ref?) {
        self.title = title
        self.type = type
        self.description = description
        self.queryNetworkStartTimeResponseRequired = queryNetworkStartTimeResponseRequired
        self.additionalProperties = additionalProperties
        self.properties = properties
        self.ref = ref
    }
}
