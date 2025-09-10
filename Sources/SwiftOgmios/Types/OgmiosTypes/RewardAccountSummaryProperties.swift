// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rewardAccountSummaryProperties = try? newJSONDecoder().decode(RewardAccountSummaryProperties.self, from: jsonData)

import Foundation

// MARK: - RewardAccountSummaryProperties
public struct RewardAccountSummaryProperties: Codable, Sendable {
    public let from, credential: PropertyNames
    public let stakePool: StakePool
    public let delegateRepresentative, rewards, deposit: PropertyNames

    public init(from: PropertyNames, credential: PropertyNames, stakePool: StakePool, delegateRepresentative: PropertyNames, rewards: PropertyNames, deposit: PropertyNames) {
        self.from = from
        self.credential = credential
        self.stakePool = stakePool
        self.delegateRepresentative = delegateRepresentative
        self.rewards = rewards
        self.deposit = deposit
    }
}
