import Foundation

/// A dynamic coding key for handling arbitrary string keys in JSON
struct DynamicStringKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

/// Rewards that can be expected assuming a pool is fully saturated.
/// Such rewards are said non-myopic, in opposition to short-sighted rewards looking at immediate benefits.
/// Keys of the map can be either Lovelace amounts or account credentials depending on the query.
public enum ProjectedRewards: JSONSerializable, Sendable {
    case lovelaces(ProjectedRewardsLovelaces)
    case credentials(ProjectedRewardsCredentials)
    
    public struct ProjectedRewardsLovelaces: StringCallable {
        public let value: Dictionary<Bech32, Dictionary<StakePoolId, ValueAdaOnly>>
        
        public init(_ value: Dictionary<Bech32, Dictionary<StakePoolId, ValueAdaOnly>>) throws {
            self.value = value
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let dictValue = try? container.decode([Bech32: Dictionary<StakePoolId, ValueAdaOnly>].self) {
                try self.init(dictValue)
            } else {
                throw DecodingError.typeMismatch(
                    Dictionary<Int, Dictionary<StakePoolId, ValueAdaOnly>>.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected dictionary but found different type"
                    )
                )
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
    
    public struct ProjectedRewardsCredentials: StringCallable {
        public let value: Dictionary<String, Dictionary<StakePoolId, ValueAdaOnly>>
        
        public init(_ value: Dictionary<String, Dictionary<StakePoolId, ValueAdaOnly>>) throws {
            self.value = value
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicStringKey.self)
            var result: [String: Dictionary<StakePoolId, ValueAdaOnly>] = [:]
            
            for key in container.allKeys {
                let poolRewards = try container.decode([String: ValueAdaOnly].self, forKey: key)
                var stakePoolRewards: [StakePoolId: ValueAdaOnly] = [:]
                
                for (poolIdStr, reward) in poolRewards {
                    let poolId = try StakePoolId(poolIdStr)
                    stakePoolRewards[poolId] = reward
                }
                
                result[key.stringValue] = stakePoolRewards
            }
            
            try self.init(result)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }

    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try credentials first (string keys for lovelace amounts like "1000000")
        if let credentialDict = try? container.decode(ProjectedRewardsCredentials.self) {
            self = .credentials(credentialDict)
            return
        }
        
        // Then try lovelaces (Bech32 keys for account credentials)
        if let lovelaceDict = try? container.decode(ProjectedRewardsLovelaces.self) {
            self = .lovelaces(lovelaceDict)
            return
        }
        
        throw DecodingError.typeMismatch(
            ProjectedRewards.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected dictionary with either String or Bech32 keys."
            )
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .lovelaces(let lovelaceDict):
                try container.encode(lovelaceDict)
            case .credentials(let credentialDict):
                try container.encode(credentialDict)
        }
    }
}
