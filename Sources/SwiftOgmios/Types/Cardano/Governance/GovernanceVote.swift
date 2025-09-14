
/// A vote on a governance proposal. The 'anchor' is optional and 'proposal' is only present from Conway onwards.
/// Before Conway, a vote would always refer to all proposals part of the same transaction.
public struct GovernanceVote: JSONSerializable {
    public let issuer: GovernanceVoter
    public let metadata: Anchor?
    public let vote: VoteChoice
    public let proposal: GovernanceProposalReference?
}

public enum VoteChoice: String, JSONSerializable {
    case yes
    case no
    case abstain
}

public enum GovernanceVoter: JSONSerializable {
    case genesisDelegate(GenesisDelegate)
    case constitutionalCommittee(ConstitutionalCommittee)
    case delegateRepresentative(DelegateRepresentative)
    case stakePoolOperator(StakePoolOperator)

    public enum CodingKeys: String, CodingKey {
        case role
    }
    
    public var description: String {
        switch self {
            case .genesisDelegate: return "genesisDelegate"
            case .constitutionalCommittee: return "constitutionalCommittee"
            case .delegateRepresentative: return "delegateRepresentative"
            case .stakePoolOperator: return "stakePoolOperator"
        }
    }
    
    public struct GenesisDelegate: JSONSerializable {
        public let role: String
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
        
        public init(
            role: String = "genesisDelegate",
            id: DigestBlake2b224,
            from: CredentialOrigin
        ) {
            guard role == "genesisDelegate" else {
                fatalError("Type must be 'genesisDelegate'")
            }
            self.role = role
            self.id = id
            self.from = from
        }
    }
    
    public struct ConstitutionalCommittee: JSONSerializable {
        public let role: String
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
        
        public init(
            role: String = "constitutionalCommittee",
            id: DigestBlake2b224,
            from: CredentialOrigin
        ) {
            guard role == "constitutionalCommittee" else {
                fatalError("Type must be 'constitutionalCommittee'")
            }
            self.role = role
            self.id = id
            self.from = from
        }
    }
    
    public struct DelegateRepresentative: JSONSerializable {
        public let role: String
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
        
        public init(
            role: String = "delegateRepresentative",
            id: DigestBlake2b224,
            from: CredentialOrigin
        ) {
            guard role == "delegateRepresentative" else {
                fatalError("Type must be 'delegateRepresentative'")
            }
            self.role = role
            self.id = id
            self.from = from
        }
    }
    
    public struct StakePoolOperator: JSONSerializable {
        public let role: String
        public let id: StakePoolId
        
        public init(
            role: String = "stakePoolOperator",
            id: StakePoolId
        ) {
            guard role == "stakePoolOperator" else {
                fatalError("Type must be 'stakePoolOperator'")
            }
            self.role = role
            self.id = id
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let role = try container.decode(String.self, forKey: .role)
        switch role {
            case "genesisDelegate":
                self = .genesisDelegate(try GenesisDelegate(from: decoder))
            case "constitutionalCommittee":
                self = .constitutionalCommittee(try ConstitutionalCommittee(from: decoder))
            case "delegateRepresentative":
                self = .delegateRepresentative(try DelegateRepresentative(from: decoder))
            case "stakePoolOperator":
                self = .stakePoolOperator(try StakePoolOperator(from: decoder))
            default:
                throw OgmiosError.decodingError("Unknown GovernanceVoter role: \(role)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
            case .genesisDelegate(let genesisDelegate):
                try genesisDelegate.encode(to: encoder)
            case .constitutionalCommittee(let constitutionalCommittee):
                try constitutionalCommittee.encode(to: encoder)
            case .delegateRepresentative(let delegateRepresentative):
                try delegateRepresentative.encode(to: encoder)
            case .stakePoolOperator(let stakePoolOperator):
                try stakePoolOperator.encode(to: encoder)
        }
    }
}
    
