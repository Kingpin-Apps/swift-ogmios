// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mempoolSizeAndCapacity = try? newJSONDecoder().decode(MempoolSizeAndCapacity.self, from: jsonData)

import Foundation

// MARK: - MempoolSizeAndCapacity
public struct MempoolSizeAndCapacity: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let mempoolSizeAndCapacityRequired: [String]
    public let properties: MempoolSizeAndCapacityProperties

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case mempoolSizeAndCapacityRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, mempoolSizeAndCapacityRequired: [String], properties: MempoolSizeAndCapacityProperties) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.mempoolSizeAndCapacityRequired = mempoolSizeAndCapacityRequired
        self.properties = properties
    }
}
