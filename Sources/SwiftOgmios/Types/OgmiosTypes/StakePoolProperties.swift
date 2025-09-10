// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stakePoolProperties = try? newJSONDecoder().decode(StakePoolProperties.self, from: jsonData)

import Foundation

// MARK: - StakePoolProperties
public struct StakePoolProperties: Codable, Sendable {
    public let id: PropertyNames

    public init(id: PropertyNames) {
        self.id = id
    }
}
