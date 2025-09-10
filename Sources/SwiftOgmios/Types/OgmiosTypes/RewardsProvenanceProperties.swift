// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rewardsProvenanceProperties = try? newJSONDecoder().decode(RewardsProvenanceProperties.self, from: jsonData)

import Foundation

// MARK: - RewardsProvenanceProperties
public struct RewardsProvenanceProperties: Codable, Sendable {
    public let totalStake, activeStake, fees, incentives: PropertyNames
    public let treasuryTax, totalRewards, efficiency: PropertyNames
    public let stakePools: PurpleStakePools

    public init(totalStake: PropertyNames, activeStake: PropertyNames, fees: PropertyNames, incentives: PropertyNames, treasuryTax: PropertyNames, totalRewards: PropertyNames, efficiency: PropertyNames, stakePools: PurpleStakePools) {
        self.totalStake = totalStake
        self.activeStake = activeStake
        self.fees = fees
        self.incentives = incentives
        self.treasuryTax = treasuryTax
        self.totalRewards = totalRewards
        self.efficiency = efficiency
        self.stakePools = stakePools
    }
}
