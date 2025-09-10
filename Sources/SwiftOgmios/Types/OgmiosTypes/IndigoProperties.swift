// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let indigoProperties = try? newJSONDecoder().decode(IndigoProperties.self, from: jsonData)

import Foundation

// MARK: - IndigoProperties
public struct IndigoProperties: Codable, Sendable {
    public let stake, vrf: PropertyNames

    public init(stake: PropertyNames, vrf: PropertyNames) {
        self.stake = stake
        self.vrf = vrf
    }
}
