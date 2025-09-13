import Foundation

// MARK: - Supporting Types

/// A delegate representative for reward account summaries (simpler than DelegateRepresentativeSummary)
public enum DelegateRepresentative: Codable, Sendable {
    case registered(Registered)
    case noConfidence
    case abstain
    
    public struct Registered: Codable, Sendable {
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
        public let type: String
        
        public init(id: DigestBlake2b224, from: CredentialOrigin, type: String = "registered") {
            self.id = id
            self.from = from
            self.type = type
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "registered":
            let id = try container.decode(DigestBlake2b224.self, forKey: .id)
            let from = try container.decode(CredentialOrigin.self, forKey: .from)
            self = .registered(Registered(id: id, from: from, type: type))
        case "noConfidence":
            self = .noConfidence
        case "abstain":
            self = .abstain
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unknown DelegateRepresentative type: \(type)"
                )
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .registered(let registered):
            try container.encode(registered.type, forKey: .type)
            try container.encode(registered.id, forKey: .id)
            try container.encode(registered.from, forKey: .from)
        case .noConfidence:
            try container.encode("noConfidence", forKey: .type)
        case .abstain:
            try container.encode("abstain", forKey: .type)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type, id, from
    }
}

/// Stake pool information within a reward account summary
public struct StakePoolInfo: Codable, Sendable {
    public let id: StakePoolId
    
    public init(id: StakePoolId) {
        self.id = id
    }
}

// MARK: - Main Type

/// Summary of a reward account's delegation settings and rewards
public struct RewardAccountSummary: Codable, Sendable {
    
    /// Origin of the stake credential (verificationKey or script)
    public let from: CredentialOrigin
    
    /// The stake credential identifier
    public let credential: DigestBlake2b224
    
    /// The stake pool this account is delegated to (optional)
    public let stakePool: StakePoolInfo?
    
    /// The delegate representative this account is delegated to (optional)
    public let delegateRepresentative: DelegateRepresentative?
    
    /// Current rewards available for withdrawal
    public let rewards: ValueAdaOnly
    
    /// Deposit associated with the stake credential registration
    public let deposit: ValueAdaOnly
    
    public init(
        from: CredentialOrigin,
        credential: DigestBlake2b224,
        stakePool: StakePoolInfo? = nil,
        delegateRepresentative: DelegateRepresentative? = nil,
        rewards: ValueAdaOnly,
        deposit: ValueAdaOnly
    ) {
        self.from = from
        self.credential = credential
        self.stakePool = stakePool
        self.delegateRepresentative = delegateRepresentative
        self.rewards = rewards
        self.deposit = deposit
    }
}

