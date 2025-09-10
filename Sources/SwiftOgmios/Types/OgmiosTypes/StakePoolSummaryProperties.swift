// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stakePoolSummaryProperties = try? newJSONDecoder().decode(StakePoolSummaryProperties.self, from: jsonData)

import Foundation

// MARK: - StakePoolSummaryProperties
public struct StakePoolSummaryProperties: Codable, Sendable {
    public let id, stake, ownerStake: PropertyNames
    public let approximatePerformance: ApproximatePerformance
    public let parameters: Parameters

    public init(id: PropertyNames, stake: PropertyNames, ownerStake: PropertyNames, approximatePerformance: ApproximatePerformance, parameters: Parameters) {
        self.id = id
        self.stake = stake
        self.ownerStake = ownerStake
        self.approximatePerformance = approximatePerformance
        self.parameters = parameters
    }
}
