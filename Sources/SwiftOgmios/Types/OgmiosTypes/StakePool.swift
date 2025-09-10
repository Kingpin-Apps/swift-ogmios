// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stakePool = try? newJSONDecoder().decode(StakePool.self, from: jsonData)

import Foundation

// MARK: - StakePool
public struct StakePool: Codable, Sendable {
    public let type: String?
    public let additionalProperties: Bool?
    public let stakePoolRequired: [String]?
    public let properties: StakePoolProperties?
    public let ref: String?

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case stakePoolRequired = "required"
        case properties
        case ref = "$ref"
    }

    public init(type: String?, additionalProperties: Bool?, stakePoolRequired: [String]?, properties: StakePoolProperties?, ref: String?) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.stakePoolRequired = stakePoolRequired
        self.properties = properties
        self.ref = ref
    }
}
