//
//  
//  Product: SwiftOgmios
//  Project: SwiftOgmios
//  Package: SwiftOgmios
//  
//  Created by Hareem Adderley on 13/09/2025 AT 1:05 PM
//  Copyright © 2025 Kingpin Apps. All rights reserved.
//  

import Foundation

/// Details about rewards calculation for the ongoing epoch.
/// Contains comprehensive information about stake distribution, rewards calculation,
/// and individual stake pool performance data.
public struct RewardsProvenance: Codable, Sendable {
    /// Total stake in the system (active + inactive)
    public let totalStake: ValueAdaOnly
    
    /// Active stake participating in the protocol
    public let activeStake: ValueAdaOnly
    
    /// Total transaction fees collected
    public let fees: ValueAdaOnly
    
    /// Additional monetary incentives from the reserve
    public let incentives: ValueAdaOnly
    
    /// Amount allocated to the treasury
    public let treasuryTax: ValueAdaOnly
    
    /// Total rewards available for distribution
    public let totalRewards: ValueAdaOnly
    
    /// Efficiency measure for the epoch (as a ratio)
    public let efficiency: Ratio
    
    /// Details about individual stake pools' rewards calculations
    public let stakePools: [StakePoolId: StakePoolRewardsProvenance]
    
    public init(
        totalStake: ValueAdaOnly,
        activeStake: ValueAdaOnly,
        fees: ValueAdaOnly,
        incentives: ValueAdaOnly,
        treasuryTax: ValueAdaOnly,
        totalRewards: ValueAdaOnly,
        efficiency: Ratio,
        stakePools: [StakePoolId: StakePoolRewardsProvenance]
    ) {
        self.totalStake = totalStake
        self.activeStake = activeStake
        self.fees = fees
        self.incentives = incentives
        self.treasuryTax = treasuryTax
        self.totalRewards = totalRewards
        self.efficiency = efficiency
        self.stakePools = stakePools
    }
    
    // Custom decoding to handle the dictionary keys properly
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        totalStake = try container.decode(ValueAdaOnly.self, forKey: .totalStake)
        activeStake = try container.decode(ValueAdaOnly.self, forKey: .activeStake)
        fees = try container.decode(ValueAdaOnly.self, forKey: .fees)
        incentives = try container.decode(ValueAdaOnly.self, forKey: .incentives)
        treasuryTax = try container.decode(ValueAdaOnly.self, forKey: .treasuryTax)
        totalRewards = try container.decode(ValueAdaOnly.self, forKey: .totalRewards)
        efficiency = try container.decode(Ratio.self, forKey: .efficiency)
        
        // Decode stakePools from string keys to StakePoolId keys
        let stakePoolsContainer = try container.decode([String: StakePoolRewardsProvenance].self, forKey: .stakePools)
        stakePools = try Dictionary(uniqueKeysWithValues: 
            stakePoolsContainer.map { key, value in 
                (try StakePoolId(key), value)
            }
        )
    }
    
    // Custom encoding to handle the dictionary keys properly
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(totalStake, forKey: .totalStake)
        try container.encode(activeStake, forKey: .activeStake)
        try container.encode(fees, forKey: .fees)
        try container.encode(incentives, forKey: .incentives)
        try container.encode(treasuryTax, forKey: .treasuryTax)
        try container.encode(totalRewards, forKey: .totalRewards)
        try container.encode(efficiency, forKey: .efficiency)
        
        // Encode stakePools with string keys
        let stringKeyedStakePools = Dictionary(uniqueKeysWithValues: 
            stakePools.map { key, value in 
                (key.value, value)
            }
        )
        try container.encode(stringKeyedStakePools, forKey: .stakePools)
    }
    
    private enum CodingKeys: String, CodingKey {
        case totalStake
        case activeStake
        case fees
        case incentives
        case treasuryTax
        case totalRewards
        case efficiency
        case stakePools
    }
}

/// Rewards provenance information for a specific stake pool
public struct StakePoolRewardsProvenance: Codable, Sendable {
    /// The pool's stake relative to total active stake
    public let relativeStake: Ratio
    
    /// Number of blocks this pool produced in the epoch
    public let blocksMade: UInt32
    
    /// Total rewards earned by this pool
    public let totalRewards: ValueAdaOnly
    
    /// Reward allocated to the pool leader
    public let leaderReward: ValueAdaOnly
    
    /// List of delegators and their stake in this pool
    public let delegators: [Delegator]
    
    public init(
        relativeStake: Ratio,
        blocksMade: UInt32,
        totalRewards: ValueAdaOnly,
        leaderReward: ValueAdaOnly,
        delegators: [Delegator]
    ) {
        self.relativeStake = relativeStake
        self.blocksMade = blocksMade
        self.totalRewards = totalRewards
        self.leaderReward = leaderReward
        self.delegators = delegators
    }
}

/// Information about a delegator within a stake pool's rewards calculation
public struct Delegator: Codable, Sendable {
    /// Origin of the delegator's stake credential
    public let from: CredentialOrigin
    
    /// The delegator's stake credential identifier
    public let credential: DigestBlake2b224
    
    /// Amount of stake delegated by this delegator
    public let stake: ValueAdaOnly
    
    public init(
        from: CredentialOrigin,
        credential: DigestBlake2b224,
        stake: ValueAdaOnly
    ) {
        self.from = from
        self.credential = credential
        self.stake = stake
    }
}

