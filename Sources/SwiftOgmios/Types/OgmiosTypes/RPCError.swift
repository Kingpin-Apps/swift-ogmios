// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rPCError = try? newJSONDecoder().decode(RPCError.self, from: jsonData)

import Foundation

// MARK: - RPCError
public struct RPCError: Codable, Sendable {
    public let title, description: String
    public let type: DeserialisationFailureType
    public let rpcErrorRequired: [AcquireLedgerStateRequired]
    public let additionalProperties: Bool
    public let examples: [RPCErrorExample]
    public let properties: RPCErrorProperties

    public enum CodingKeys: String, CodingKey {
        case title, description, type
        case rpcErrorRequired = "required"
        case additionalProperties, examples, properties
    }

    public init(title: String, description: String, type: DeserialisationFailureType, rpcErrorRequired: [AcquireLedgerStateRequired], additionalProperties: Bool, examples: [RPCErrorExample], properties: RPCErrorProperties) {
        self.title = title
        self.description = description
        self.type = type
        self.rpcErrorRequired = rpcErrorRequired
        self.additionalProperties = additionalProperties
        self.examples = examples
        self.properties = properties
    }
}
