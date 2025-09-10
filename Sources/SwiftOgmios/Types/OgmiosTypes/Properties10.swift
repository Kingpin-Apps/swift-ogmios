// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties10 = try? newJSONDecoder().decode(Properties10.self, from: jsonData)

import Foundation

// MARK: - Properties10
public struct Properties10: Codable, Sendable {
    public let cbor: StakePoolPledgeInfluence

    public init(cbor: StakePoolPledgeInfluence) {
        self.cbor = cbor
    }
}
