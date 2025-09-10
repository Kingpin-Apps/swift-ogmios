
/// An era bound which captures the time, slot and epoch at which the era start. The time is relative to the start time of the network.
public struct Constitution: Codable, Sendable {
    public let guardrails: ConstitutionGuardrails?
    public let metadata: Anchor
}

public struct ConstitutionGuardrails: Codable, Sendable {
    public let hash: DigestBlake2b224
}

public enum ConstitutionalCommitteeMemberStatus: String, Codable, Sendable {
    case active
    case expired
    case unrecognized
}


public enum ConstitutionalCommitteeDelegate: Codable, Sendable {
    case authorized(Authorized)
    case resigned(Resigned)
    case none(None)
    
    public enum CodingKeys: String, CodingKey {
        case status
    }
    
    public struct Authorized: Codable, Sendable {
        public var status: String = "authorized"
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
    }
    
    public struct Resigned: Codable, Sendable {
        public var status: String = "resigned"
        public let metadata: Anchor
    }
    
    public struct None: Codable, Sendable {
        public var status: String = "none"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(String.self, forKey: .status)
        switch status {
            case "authorized":
                self = .authorized(try Authorized(from: decoder))
            case "resigned":
                self = .resigned(try Resigned(from: decoder))
            case "none":
                self = .none(try None(from: decoder))
            default:
                throw OgmiosError.decodingError("Unknown ConstitutionalCommitteeDelegate status: \(status)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
            case .authorized(let authorized):
                try authorized.encode(to: encoder)
            case .resigned(let resigned):
                try resigned.encode(to: encoder)
            case .none(let none):
                try none.encode(to: encoder)
        }
    }
}

public enum ConstitutionalCommitteeMemberChangeStatus: String, Codable, Sendable {
    case toBeEnacted
    case toBeRemoved
    case expiring
    case adjustingMandate
}

public struct ConstitutionalCommitteeMemberNext: Codable, Sendable {
    public let change: ConstitutionalCommitteeMemberChangeStatus
    public let mandate: Mandate?
}

public struct ConstitutionalCommitteeMember: Codable, Sendable {
    public let id: DigestBlake2b224
    public let from: CredentialOrigin
    
    /// A member status. 'active' indicates that this member vote will count during the ratification of the ongoing epoch.
    /// 'unrecognized' means that some hot credential currently points to a non-existing (or no longer existing) member.
    public let status: ConstitutionalCommitteeMemberStatus
    
    public let delegate: ConstitutionalCommitteeDelegate
    public let mandate: Mandate?
    public let next: ConstitutionalCommitteeMemberNext?
}



