import Foundation

// MARK: - GovernanceAction
public enum GovernanceAction: JSONSerializable {
    case protocolParametersUpdate(ProtocolParametersUpdate)
    case hardForkInitiation(HardForkInitiation)
    case treasuryTransfer(TreasuryTransfer)
    case treasuryWithdrawals(TreasuryWithdrawals)
    case constitutionalCommittee(ConstitutionalCommittee)
    case constitution(Constitution)
    case noConfidence(NoConfidence)
    case information(Information)
    
    public var description: String {
        switch self {
            case .protocolParametersUpdate: return "protocolParametersUpdate"
            case .hardForkInitiation: return "hardForkInitiation"
            case .treasuryTransfer: return "treasuryTransfer"
            case .treasuryWithdrawals: return "treasuryWithdrawals"
            case .constitutionalCommittee: return "constitutionalCommittee"
            case .constitution: return "constitution"
            case .noConfidence: return "noConfidence"
            case .information: return "information"
        }
    }
    
    public enum CodingKeys: String, CodingKey {
        case type
    }
    
    /// The 'ancestor' is a reference to the previous governance action of this group.
    /// It is optional for the first one and required after so that they all actions of a same group form a chain.
    public struct ProtocolParametersUpdate: JSONSerializable {
        /// A special delegate representative which always abstain.
        public let type: String 
        public let ancestor: GovernanceProposalReference?
        public let parameters: ProposedProtocolParameters
        public let guardrails: Guardrails?
        
        public init(
            type: String = "protocolParametersUpdate",
            parameters: ProposedProtocolParameters,
            ancestor: GovernanceProposalReference? = nil,
            guardrails: Guardrails? = nil
        ) {
            guard type == "protocolParametersUpdate" else {
                fatalError("Type must be 'protocolParametersUpdate'")
            }
            self.type = type
            self.parameters = parameters
            self.ancestor = ancestor
            self.guardrails = guardrails
        }
    }
    
    public struct HardForkInitiation: JSONSerializable {
        public let type: String
        public let ancestor: GovernanceProposalReference?
        public let version: ProtocolVersion
        
        public init(
            type: String = "hardForkInitiation",
            version: ProtocolVersion,
            ancestor: GovernanceProposalReference? = nil
        ) {
            guard type == "hardForkInitiation" else {
                fatalError("Type must be 'hardForkInitiation'")
            }
            self.type = type
            self.version = version
            self.ancestor = ancestor
        }
    }
    
    /// A transfer from or to the treasury / reserves authored by genesis delegates.
    public struct TreasuryTransfer: JSONSerializable {
        public let type: String
        public let source: Source
        public let target: Source
        public let value: ValueAdaOnly
        
        public enum Source: String, JSONSerializable {
            case reserves
            case treasury
        }
        
        public init(
            type: String = "treasuryTransfer",
            source: Source,
            target: Source,
            value: ValueAdaOnly
        ) {
            guard type == "treasuryTransfer" else {
                fatalError("Type must be 'treasuryTransfer'")
            }
            self.type = type
            self.source = source
            self.target = target
            self.value = value
        }
    }
    
    /// One of more withdrawals from the treasury.
    public struct TreasuryWithdrawals: JSONSerializable {
        public let type: String
        public let withdrawals: RewardTransfer
        public let guardrails: Guardrails?
        
        public init(
            type: String = "treasuryWithdrawals",
            withdrawals: RewardTransfer,
            guardrails: Guardrails? = nil
        ) {
            guard type == "treasuryWithdrawals" else {
                fatalError("Type must be 'treasuryWithdrawals'")
            }
            self.type = type
            self.withdrawals = withdrawals
            self.guardrails = guardrails
        }
    }
    
    /// A change (partial or total) in the constitutional committee. The 'ancestor' is a reference to the
    /// previous governance action of this group (also includes no confidence actions in this case).
    /// It is optional for the first one and required after so that they all actions of a same group form a chain.
    public struct ConstitutionalCommittee: JSONSerializable {
        public let type: String
        public let ancestor: GovernanceProposalReference?
        public let members: Members
        public let quorum: Ratio?
        
        public struct Members: JSONSerializable {
            public let added: [ConstitutionalCommitteeMemberSummary]?
            public let removed: [Members]?
            
            public init(
                added: [ConstitutionalCommitteeMemberSummary]? = nil,
                removed: [Members]? = nil
            ) {
                self.added = added
                self.removed = removed
            }
            
        }
        
        public init(
            type: String = "constitutionalCommittee",
            ancestor: GovernanceProposalReference? = nil,
            members: Members,
            quorum: Ratio? = nil
        ) {
            guard type == "constitutionalCommittee" else {
                fatalError("Type must be 'constitutionalCommittee'")
            }
            self.type = type
            self.ancestor = ancestor
            self.members = members
            self.quorum = quorum
        }
    }
    
    /// A change in the constitution. Only its hash is recorded on-chain.
    /// The 'ancestor' is a reference to the previous governance action of this group.
    /// It is optional for the first one and required after so that they all actions of a same group form a chain.
    public struct Constitution: JSONSerializable {
        public let type: String
        public let ancestor: GovernanceProposalReference?
        public let guardrails: Guardrails?
        public let metadata: Anchor
        
        public init(
            type: String = "constitution",
            ancestor: GovernanceProposalReference? = nil,
            guardrails: Guardrails? = nil,
            metadata: Anchor
        ) {
            guard type == "constitution" else {
                fatalError("Type must be 'constitution'")
            }
            self.type = type
            self.ancestor = ancestor
            self.guardrails = guardrails
            self.metadata = metadata
        }
    }
    
    /// A motion of no-confidence, indicate a lack of trust in the constitutional committee.
    /// The 'ancestor' is a reference to the previous governance action of this group.
    ///  It is optional for the first one and required after so that they all actions of a same group form a chain.
    public struct NoConfidence: JSONSerializable {
        public let type: String
        public let ancestor: GovernanceProposalReference?
        
        public init(
            type: String = "noConfidence",
            ancestor: GovernanceProposalReference? = nil,
        ) {
            guard type == "noConfidence" else {
                fatalError("Type must be 'noConfidence'")
            }
            self.type = type
            self.ancestor = ancestor
        }
    }
    
    /// An action that has no effect on-chain, other than an on-chain record
    public struct Information: JSONSerializable {
        public let type: String
        
        public init(
            type: String = "information",
            ancestor: GovernanceProposalReference? = nil,
        ) {
            guard type == "information" else {
                fatalError("Type must be 'information'")
            }
            self.type = type
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
            case "protocolParametersUpdate":
                self = .protocolParametersUpdate(try ProtocolParametersUpdate(from: decoder))
            case "hardForkInitiation":
                self = .hardForkInitiation(try HardForkInitiation(from: decoder))
            case "treasuryTransfer":
                self = .treasuryTransfer(try TreasuryTransfer(from: decoder))
            case "treasuryWithdrawals":
                self = .treasuryWithdrawals(try TreasuryWithdrawals(from: decoder))
            case "constitutionalCommittee":
                self = .constitutionalCommittee(try ConstitutionalCommittee(from: decoder))
            case "constitution":
                self = .constitution(try Constitution(from: decoder))
            case "noConfidence":
                self = .noConfidence(try NoConfidence(from: decoder))
            case "information":
                self = .information(try Information(from: decoder))
            default:
                throw OgmiosError.decodingError("Unknown GovernanceAction type: \(type)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
            case .protocolParametersUpdate(let action):
                try action.encode(to: encoder)
            case .hardForkInitiation(let action):
                try action.encode(to: encoder)
            case .treasuryTransfer(let action):
                try action.encode(to: encoder)
            case .treasuryWithdrawals(let action):
                try action.encode(to: encoder)
            case .constitutionalCommittee(let action):
                try action.encode(to: encoder)
            case .constitution(let action):
                try action.encode(to: encoder)
            case .noConfidence(let action):
                try action.encode(to: encoder)
            case .information(let action):
                try action.encode(to: encoder)
        }
    }
}
