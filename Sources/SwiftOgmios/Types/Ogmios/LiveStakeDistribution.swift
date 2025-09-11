/// Distribution of stake across registered stake pools. Each key in the map corresponds to a pool id.
public struct LiveStakeDistribution: StringCallable {
    public let value: Dictionary<StakePoolId, LiveStakeDistributionPool>
    
    public init(_ value: Dictionary<StakePoolId, LiveStakeDistributionPool>) throws {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // Explicitly decode as dictionary, not array
        if let dictValue = try? container.decode([String: LiveStakeDistributionPool].self) {
            // Convert string keys to StakePoolId
            let converted = try Dictionary(uniqueKeysWithValues: 
                dictValue.map { key, value in 
                    (try StakePoolId(key), value)
                }
            )
            try self.init(converted)
        } else {
            throw DecodingError.typeMismatch(
                Dictionary<StakePoolId, LiveStakeDistributionPool>.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected dictionary but found different type"
                )
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        // Convert Dictionary<StakePoolId, LiveStakeDistributionPool> to [String: LiveStakeDistributionPool]
        let stringDict = Dictionary(uniqueKeysWithValues: 
            value.map { key, value in 
                (key.value, value)
            }
        )
        try container.encode(stringDict)
    }
}

public struct LiveStakeDistributionPool: JSONSerializable, Equatable, Hashable, Sendable {
    public let stake: Ratio
    public let vrf: DigestBlake2b256
}
