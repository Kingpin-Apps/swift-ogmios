
public struct Constitution: JSONSerializable {
    public let guardrails: Guardrails?
    public let metadata: Anchor
}

public enum ConstitutionalCommitteeMemberStatus: String, JSONSerializable {
    case active
    case expired
    case unrecognized
}


public enum ConstitutionalCommitteeDelegate: JSONSerializable {
    case authorized(Authorized)
    case resigned(Resigned)
    case none(None)
    
    public enum CodingKeys: String, CodingKey {
        case status
    }
    
    public struct Authorized: JSONSerializable {
        public var status: String = "authorized"
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
    }
    
    public struct Resigned: JSONSerializable {
        public var status: String = "resigned"
        public let metadata: Anchor
    }
    
    public struct None: JSONSerializable {
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

public enum ConstitutionalCommitteeMemberChangeStatus: JSONSerializable {
    case toBeEnacted
    case toBeRemoved
    case expiring
    case adjustingMandate
}

public struct ConstitutionalCommitteeMemberNext: JSONSerializable {
    public let change: ConstitutionalCommitteeMemberChangeStatus
    public let mandate: Mandate?
}

public struct ConstitutionalCommitteeMember: JSONSerializable {
    public let id: DigestBlake2b224
    public let from: CredentialOrigin
    
    /// A member status. 'active' indicates that this member vote will count during the ratification of the ongoing epoch.
    /// 'unrecognized' means that some hot credential currently points to a non-existing (or no longer existing) member.
    public let status: ConstitutionalCommitteeMemberStatus
    
    public let delegate: ConstitutionalCommitteeDelegate
    public let mandate: Mandate?
    public let next: ConstitutionalCommitteeMemberNext?
}

public struct ConstitutionalCommitteeMemberSummary: JSONSerializable {
    public let id: DigestBlake2b224
    public let from: CredentialOrigin
    public let mandate: Mandate?
}



