// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rewardAccountSummaryExample = try? newJSONDecoder().decode(RewardAccountSummaryExample.self, from: jsonData)

import Foundation

// MARK: - RewardAccountSummaryExample
public struct RewardAccountSummaryExample: Codable, Sendable {
    public let from, credential: String
    public let stakePool: String?
    public let rewards, deposit: Deposit
    public let delegateRepresentative: Message?

    public init(from: String, credential: String, stakePool: String?, rewards: Deposit, deposit: Deposit, delegateRepresentative: Message?) {
        self.from = from
        self.credential = credential
        self.stakePool = stakePool
        self.rewards = rewards
        self.deposit = deposit
        self.delegateRepresentative = delegateRepresentative
    }
}
