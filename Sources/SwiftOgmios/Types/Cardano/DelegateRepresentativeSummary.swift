import Foundation

// MARK: - DelegateRepresentativeSummary
public enum DelegateRepresentativeSummary: JSONSerializable {
    case registered(Registered)
    case noConfidence(NoConfidence)
    case abstain(Abstain)
    
    public var description: String {
        switch self {
            case .registered(_): return "registered"
            case .noConfidence(_): return "noConfidence"
            case .abstain(_): return "abstain"
        }
    }
    
    public struct Registered: JSONSerializable {
        /// A special delegate representative which always abstain.
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
        public let type: String
        public let mandate: Mandate?
        public let metadata: Anchor?
        public let deposit: ValueAdaOnly?
        public let stake: ValueAdaOnly
        public let delegators: [Delegators]
        
        public init(
            id: DigestBlake2b224,
            from: CredentialOrigin,
            type: String = "registered",
            mandate: Mandate? = nil,
            metadata: Anchor? = nil,
            deposit: ValueAdaOnly? = nil,
            stake: ValueAdaOnly,
            delegators: [Delegators],
        ) {
            guard type == "registered" else {
                fatalError("Type must be 'registered'")
            }
            self.type = type
            self.stake = stake
            self.id = id
            self.from = from
            self.mandate = mandate
            self.metadata = metadata
            self.deposit = deposit
            self.delegators = delegators
        }
    }
    
    public struct Abstain: JSONSerializable {
        /// A special delegate representative which always abstain.
        public let type: String
        public let stake: ValueAdaOnly
        
        public init(
            type: String = "abstain",
            stake: ValueAdaOnly
        ) {
            guard type == "abstain" else {
                fatalError("Type must be 'abstain'")
            }
            self.type = type
            self.stake = stake
        }
    }
    
    public struct NoConfidence: JSONSerializable {
        /// A special delegate representative which always vote no, except on votes of no-confidence.
        public let type: String
        public let stake: ValueAdaOnly
        
        public init(
            type: String = "noConfidence",
            stake: ValueAdaOnly
        ) {
            guard type == "noConfidence" else {
                fatalError("Type must be 'noConfidence'")
            }
            self.type = type
            self.stake = stake
        }
    }
    
    private enum TypeKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        // Dispatch on the `type` discriminator: the abstain and noConfidence
        // payloads have identical shapes, so trial decoding cannot tell them apart.
        let keyed = try decoder.container(keyedBy: TypeKey.self)
        let type = try keyed.decode(String.self, forKey: .type)
        let container = try decoder.singleValueContainer()
        switch type {
            case "registered":
                self = .registered(try container.decode(Registered.self))
            case "noConfidence":
                self = .noConfidence(try container.decode(NoConfidence.self))
            case "abstain":
                self = .abstain(try container.decode(Abstain.self))
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: keyed,
                    debugDescription: "Unknown type for DelegateRepresentativeSummary: \(type)"
                )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .registered(let registered):
                try container.encode(registered)
            case .noConfidence(let noConfidence):
                try container.encode(noConfidence)
            case .abstain(let abstain):
                try container.encode(abstain)
        }
    }
}


