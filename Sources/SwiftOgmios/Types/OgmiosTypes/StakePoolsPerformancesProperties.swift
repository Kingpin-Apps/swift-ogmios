// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stakePoolsPerformancesProperties = try? newJSONDecoder().decode(StakePoolsPerformancesProperties.self, from: jsonData)

import Foundation

// MARK: - StakePoolsPerformancesProperties
public struct StakePoolsPerformancesProperties: Codable, Sendable {
    public let desiredNumberOfStakePools: ApproximatePerformance
    public let stakePoolPledgeInfluence: StakePoolPledgeInfluence
    public let totalRewardsInEpoch, totalStakeInEpoch, activeStakeInEpoch: PropertyNames
    public let stakePools: FluffyStakePools

    public init(desiredNumberOfStakePools: ApproximatePerformance, stakePoolPledgeInfluence: StakePoolPledgeInfluence, totalRewardsInEpoch: PropertyNames, totalStakeInEpoch: PropertyNames, activeStakeInEpoch: PropertyNames, stakePools: FluffyStakePools) {
        self.desiredNumberOfStakePools = desiredNumberOfStakePools
        self.stakePoolPledgeInfluence = stakePoolPledgeInfluence
        self.totalRewardsInEpoch = totalRewardsInEpoch
        self.totalStakeInEpoch = totalStakeInEpoch
        self.activeStakeInEpoch = activeStakeInEpoch
        self.stakePools = stakePools
    }
}
