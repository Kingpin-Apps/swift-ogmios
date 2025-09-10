// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tentacledStakePools = try? newJSONDecoder().decode(TentacledStakePools.self, from: jsonData)

import Foundation

// MARK: - TentacledStakePools
public struct TentacledStakePools: Codable, Sendable {
    public let type: ExtraneousRedeemersType
    public let items: StakePool

    public init(type: ExtraneousRedeemersType, items: StakePool) {
        self.type = type
        self.items = items
    }
}
