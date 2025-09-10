import Foundation

// MARK: - PointOrOrigin
public enum DelegateRepresentativeSummary: JSONSerializable, Sendable {
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
    
    public struct Registered: Codable, Sendable {
        /// A special delegate representative which always abstain.
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
        public let type: String
        public let mandate: Mandate?
        public let metadata: Anchor?
        public let deposit: ValueAdaOnly?
        public let stake: ValueAdaOnly
        
        public init(
            id: DigestBlake2b224,
            from: CredentialOrigin,
            type: String = "registered",
            mandate: Mandate? = nil,
            metadata: Anchor? = nil,
            deposit: ValueAdaOnly? = nil,
            stake: ValueAdaOnly,
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
        }
    }
    
    public struct Abstain: Codable, Sendable {
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
    
    public struct NoConfidence: Codable, Sendable {
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let registered = try? container.decode(Registered.self) {
            self = .registered(registered)
            return
        }
        else if let noConfidence = try? container.decode(NoConfidence.self) {
            self = .noConfidence(noConfidence)
            return
        }
        else if let abstain = try? container.decode(Abstain.self) {
            self = .abstain(abstain)
            return
        } else {
            throw DecodingError.typeMismatch(
                DelegateRepresentativeSummary.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unknown type for DelegateRepresentativeSummary"
                )
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


