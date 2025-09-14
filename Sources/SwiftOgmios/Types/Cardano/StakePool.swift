import Foundation

/// A Blake2b 28-byte hash digest of a pool's verification key.
public struct StakePoolId: StringCallable {
    public let value: String
    
    public init(_ value: String) throws {
        guard value.starts(with: "pool1") else {
            throw OgmiosError
                .invalidFormat("StakePoolId must start with 'pool1', got \(value)")
        }
        
        self.value = value
    }
}

/// Complete stake pool information including parameters and metadata
public struct StakePool: JSONSerializable {
    /// The stake pool identifier
    public let id: StakePoolId
    
    /// VRF verification key hash
    public let vrfVerificationKeyHash: DigestBlake2b256
    
    /// Pool owners' key hashes
    public let owners: [DigestBlake2b224]
    
    /// Fixed cost per epoch
    public let cost: ValueAdaOnly
    
    /// Pool operator's margin (as a ratio)
    public let margin: Ratio
    
    /// Pool operator's pledge
    public let pledge: ValueAdaOnly
    
    /// Reward account for pool rewards
    public let rewardAccount: RewardAccount
    
    /// Pool metadata (optional)
    public let metadata: Anchor?
    
    /// Network relays for the pool
    public let relays: [Relay]
    
    /// Total stake delegated to this pool (optional, only when explicitly requested)
    public let stake: ValueAdaOnly?
    
    public init(
        id: StakePoolId,
        vrfVerificationKeyHash: DigestBlake2b256,
        owners: [DigestBlake2b224],
        cost: ValueAdaOnly,
        margin: Ratio,
        pledge: ValueAdaOnly,
        rewardAccount: RewardAccount,
        metadata: Anchor? = nil,
        relays: [Relay],
        stake: ValueAdaOnly? = nil
    ) {
        self.id = id
        self.vrfVerificationKeyHash = vrfVerificationKeyHash
        self.owners = owners
        self.cost = cost
        self.margin = margin
        self.pledge = pledge
        self.rewardAccount = rewardAccount
        self.metadata = metadata
        self.relays = relays
        self.stake = stake
    }
}

/// Network relay information for stake pools
public enum Relay: JSONSerializable {
    case singleHostAddr(SingleHostAddr)
    case singleHostName(SingleHostName)
    case multiHostName(MultiHostName)
    
    public struct SingleHostAddr: JSONSerializable {
        public let port: UInt16?
        public let ipv4: String?
        public let ipv6: String?
        
        public init(port: UInt16? = nil, ipv4: String? = nil, ipv6: String? = nil) {
            self.port = port
            self.ipv4 = ipv4
            self.ipv6 = ipv6
        }
    }
    
    public struct SingleHostName: JSONSerializable {
        public let port: UInt16?
        public let hostname: String
        
        public init(port: UInt16? = nil, hostname: String) {
            self.port = port
            self.hostname = hostname
        }
    }
    
    public struct MultiHostName: JSONSerializable {
        public let hostname: String
        
        public init(hostname: String) {
            self.hostname = hostname
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "singleHostAddr":
            let relay = try SingleHostAddr(from: decoder)
            self = .singleHostAddr(relay)
        case "singleHostName":
            let relay = try SingleHostName(from: decoder)
            self = .singleHostName(relay)
        case "multiHostName":
            let relay = try MultiHostName(from: decoder)
            self = .multiHostName(relay)
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unknown relay type: \(type)"
                )
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .singleHostAddr(let relay):
            try container.encode("singleHostAddr", forKey: .type)
            try relay.encode(to: encoder)
        case .singleHostName(let relay):
            try container.encode("singleHostName", forKey: .type)
            try relay.encode(to: encoder)
        case .multiHostName(let relay):
            try container.encode("multiHostName", forKey: .type)
            try relay.encode(to: encoder)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
}

