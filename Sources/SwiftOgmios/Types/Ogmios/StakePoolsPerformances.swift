import Foundation

/// Details about how rewards are calculated for the ongoing epoch.
/// Contains information about stake pool performances and related metrics.
public struct StakePoolsPerformances: Codable, Sendable {
    /// Desired number of stake pools
    public let desiredNumberOfStakePools: UInt64
    
    /// Influence of the pool owner's pledge on rewards (as a ratio)
    public let stakePoolPledgeInfluence: Ratio
    
    /// Total rewards available in this epoch
    public let totalRewardsInEpoch: ValueAdaOnly
    
    /// Active stake participating in the protocol in this epoch
    public let activeStakeInEpoch: ValueAdaOnly
    
    /// Total stake in the system in this epoch
    public let totalStakeInEpoch: ValueAdaOnly
    
    /// Details about individual stake pools' performances
    public let stakePools: [StakePoolId: StakePoolSummary]
    
    public init(
        desiredNumberOfStakePools: UInt64,
        stakePoolPledgeInfluence: Ratio,
        totalRewardsInEpoch: ValueAdaOnly,
        activeStakeInEpoch: ValueAdaOnly,
        totalStakeInEpoch: ValueAdaOnly,
        stakePools: [StakePoolId: StakePoolSummary]
    ) {
        self.desiredNumberOfStakePools = desiredNumberOfStakePools
        self.stakePoolPledgeInfluence = stakePoolPledgeInfluence
        self.totalRewardsInEpoch = totalRewardsInEpoch
        self.activeStakeInEpoch = activeStakeInEpoch
        self.totalStakeInEpoch = totalStakeInEpoch
        self.stakePools = stakePools
    }
    
    // Custom decoding to handle the dictionary keys properly
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        desiredNumberOfStakePools = try container.decode(UInt64.self, forKey: .desiredNumberOfStakePools)
        stakePoolPledgeInfluence = try container.decode(Ratio.self, forKey: .stakePoolPledgeInfluence)
        totalRewardsInEpoch = try container.decode(ValueAdaOnly.self, forKey: .totalRewardsInEpoch)
        activeStakeInEpoch = try container.decode(ValueAdaOnly.self, forKey: .activeStakeInEpoch)
        totalStakeInEpoch = try container.decode(ValueAdaOnly.self, forKey: .totalStakeInEpoch)
        
        // Decode stakePools from string keys to StakePoolId keys
        let stakePoolsContainer = try container.decode([String: StakePoolSummary].self, forKey: .stakePools)
        stakePools = try Dictionary(uniqueKeysWithValues: 
            stakePoolsContainer.map { key, value in 
                (try StakePoolId(key), value)
            }
        )
    }
    
    // Custom encoding to handle the dictionary keys properly
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(desiredNumberOfStakePools, forKey: .desiredNumberOfStakePools)
        try container.encode(stakePoolPledgeInfluence, forKey: .stakePoolPledgeInfluence)
        try container.encode(totalRewardsInEpoch, forKey: .totalRewardsInEpoch)
        try container.encode(activeStakeInEpoch, forKey: .activeStakeInEpoch)
        try container.encode(totalStakeInEpoch, forKey: .totalStakeInEpoch)
        
        // Encode stakePools with string keys
        let stringKeyedStakePools = Dictionary(uniqueKeysWithValues: 
            stakePools.map { key, value in 
                (key.value, value)
            }
        )
        try container.encode(stringKeyedStakePools, forKey: .stakePools)
    }
    
    private enum CodingKeys: String, CodingKey {
        case desiredNumberOfStakePools
        case stakePoolPledgeInfluence
        case totalRewardsInEpoch
        case activeStakeInEpoch
        case totalStakeInEpoch
        case stakePools
    }
}

/// Summary of a stake pool's performance metrics
public struct StakePoolSummary: Codable, Sendable {
    /// The stake pool identifier
    public let id: StakePoolId
    
    /// Total stake delegated to this pool
    public let stake: ValueAdaOnly
    
    /// Stake owned by the pool operators
    public let ownerStake: ValueAdaOnly
    
    /// Performance metric (blocks produced / expected blocks)
    public let approximatePerformance: Double
    
    /// Pool parameters relevant for reward calculations
    public let parameters: StakePoolParameters
    
    public init(
        id: StakePoolId,
        stake: ValueAdaOnly,
        ownerStake: ValueAdaOnly,
        approximatePerformance: Double,
        parameters: StakePoolParameters
    ) {
        self.id = id
        self.stake = stake
        self.ownerStake = ownerStake
        self.approximatePerformance = approximatePerformance
        self.parameters = parameters
    }
}

/// Parameters of a stake pool relevant for reward calculations
public struct StakePoolParameters: Codable, Sendable {
    /// Fixed cost per epoch
    public let cost: ValueAdaOnly
    
    /// Pool operator's margin (as a ratio)
    public let margin: Ratio
    
    /// Pool operator's pledge
    public let pledge: ValueAdaOnly
    
    public init(
        cost: ValueAdaOnly,
        margin: Ratio,
        pledge: ValueAdaOnly
    ) {
        self.cost = cost
        self.margin = margin
        self.pledge = pledge
    }
}
