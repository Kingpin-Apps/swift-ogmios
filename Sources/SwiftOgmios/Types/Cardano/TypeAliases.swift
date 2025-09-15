import Foundation

/// A block number, the i-th block to be minted is number i.
public typealias BlockHeight = UInt128

/// An epoch number or length.
public typealias Epoch = UInt64

/// An absolute slot number.
public typealias Slot = UInt128

/// A hash digest from an unspecified algorithm and length.
public typealias DigestAny = String

/// Number of slots from the tip of the ledger in which it is guaranteed that no hard fork can take place.
/// This should be (at least) the number of slots in which we are guaranteed to have k blocks.
public typealias SafeZone = UInt64

/// A Blake2b 32-byte hash digest of a transaction body
public typealias TransactionId = String

/// An EdDSA signature
public typealias Signature = String

/// An Ed25519-BIP32 chain-code for key deriviation
public typealias ChainCode = String

/// Extra attributes carried by Byron addresses (network magic and/or HD payload)
public typealias AddressAttributes = String

/// Assets as a nested object structure with policy IDs and asset names
public typealias Assets = [String: [String: AssetQuantity]]

/// A number of asset, can be negative when burning assets
public typealias AssetQuantity = Int64

/// Withdrawals as an object mapping stake addresses to Ada-only values
public typealias Withdrawals = [String: ValueAdaOnly]

/// Metadata associated with the transaction
public struct Metadata: Codable, Sendable, Equatable, Hashable {
    /// Hash of the metadata
    public let hash: DigestBlake2b256
    /// Labels mapping metadata keys to values
    public let labels: [String: MetadataLabel]
    
    public init(hash: DigestBlake2b256, labels: [String: MetadataLabel]) {
        self.hash = hash
        self.labels = labels
    }
}

/// A metadata label entry
public struct MetadataLabel: Codable, Sendable, Equatable, Hashable {
    /// CBOR-encoded metadata
    public let cbor: String?
    /// JSON representation if possible (as string for now, can be parsed later)
    public let json: String?
    
    public init(cbor: String? = nil, json: String? = nil) {
        self.cbor = cbor
        self.json = json
    }
}

/// A datum (script data)
public typealias Datum = String

/// A redeemer for script validation
public struct Redeemer: Codable, Sendable, Equatable, Hashable {
    /// The redeemer pointer (validator reference)
    public let validator: RedeemerPointer
    /// The actual redeemer data
    public let datum: Datum
    /// Execution units budget (references the ExecutionUnits from ProposedProtocolParameters.swift)
    public let executionUnits: SwiftOgmios.ExecutionUnits?
    
    public init(validator: RedeemerPointer, datum: Datum, executionUnits: SwiftOgmios.ExecutionUnits? = nil) {
        self.validator = validator
        self.datum = datum
        self.executionUnits = executionUnits
    }
}

public enum CredentialOrigin : String, JSONSerializable {
    case verificationKey = "verificationKey"
    case script = "script"
}

/// Certificate types for transaction certificates
public enum Certificate: Codable, Sendable, Equatable, Hashable {
    case stakeDelegation(StakeDelegation)
    case stakeCredentialRegistration(StakeCredentialRegistration)
    case stakeCredentialDeregistration(StakeCredentialDeregistration)
    case stakePoolRegistration(StakePoolRegistration)
    case stakePoolRetirement(StakePoolRetirement)
    case genesisDelegation(GenesisDelegation)
    case constitutionalCommitteeDelegation(ConstitutionalCommitteeDelegation)
    case constitutionalCommitteeRetirement(ConstitutionalCommitteeRetirement)
    case delegateRepresentativeRegistration(DelegateRepresentativeRegistration)
    case delegateRepresentativeUpdate(DelegateRepresentativeUpdate)
    case delegateRepresentativeRetirement(DelegateRepresentativeRetirement)
    
    public struct StakeDelegation: Codable, Sendable, Equatable, Hashable {
        public let credential: DigestBlake2b224
        public let from: CredentialOrigin
        public let stakePool: StakePoolRef?
        public let delegateRepresentative: GovernanceVoter.DelegateRepresentative?
    }
    
    public struct StakeCredentialRegistration: Codable, Sendable, Equatable, Hashable {
        public let credential: DigestBlake2b224
        public let from: CredentialOrigin
        public let deposit: ValueAdaOnly?
    }
    
    public struct StakeCredentialDeregistration: Codable, Sendable, Equatable, Hashable {
        public let credential: DigestBlake2b224
        public let from: CredentialOrigin
        public let deposit: ValueAdaOnly?
    }
    
    public struct StakePoolRegistration: Codable, Sendable, Equatable, Hashable {
        public let stakePool: StakePool
    }
    
    public struct StakePoolRetirement: Codable, Sendable, Equatable, Hashable {
        public let stakePool: StakePoolRef
        public let retirementEpoch: Epoch
    }
    
    public struct GenesisDelegation: Codable, Sendable, Equatable, Hashable {
        public let delegate: GovernanceVoter.GenesisDelegate
        public let issuer: DigestBlake2b224
    }
    
    public struct ConstitutionalCommitteeDelegation: Codable, Sendable, Equatable, Hashable {
        public let member: CommitteeMember
        public let delegate: GovernanceVoter.ConstitutionalCommittee
    }
    
    public struct ConstitutionalCommitteeRetirement: Codable, Sendable, Equatable, Hashable {
        public let member: CommitteeMember
        public let metadata: Anchor?
    }
    
    public struct DelegateRepresentativeRegistration: Codable, Sendable, Equatable, Hashable {
        public let delegateRepresentative: GovernanceVoter.DelegateRepresentative
        public let deposit: ValueAdaOnly
        public let metadata: Anchor?
    }
    
    public struct DelegateRepresentativeUpdate: Codable, Sendable, Equatable, Hashable {
        public let delegateRepresentative: GovernanceVoter.DelegateRepresentative
        public let metadata: Anchor?
    }
    
    public struct DelegateRepresentativeRetirement: Codable, Sendable, Equatable, Hashable {
        public let delegateRepresentative: GovernanceVoter.DelegateRepresentative
        public let deposit: ValueAdaOnly
    }
    
    // Supporting types
    public struct StakePoolRef: Codable, Sendable, Equatable, Hashable {
        public let id: StakePoolId
    }
    
    public struct CommitteeMember: Codable, Sendable, Equatable, Hashable {
        public let id: DigestBlake2b224
        public let from: CredentialOrigin
    }
}

public struct Delegators: JSONSerializable {
    public let credential: DigestBlake2b224
    public let from: CredentialOrigin
}

public struct Members: JSONSerializable {
    public let id: DigestBlake2b224
    public let from: CredentialOrigin
}

/// A ratio of two integers, to express exact fractions.
public struct Ratio: StringCallable {
    let value: String
    
    public init(_ value: String) throws {
        guard value.split(separator: "/").count == 2 else {
            throw OgmiosError.invalidFormat("Ratio must be in the format 'numerator/denominator'")
        }
                      
        self.value = value
    }
}

public struct UtcTime: StringCallable {
    let value: Date
    
    public init(_ value: Date) throws {
        self.value = value
    }
    
    public init(from string: String) throws {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: string) else {
            throw OgmiosError.invalidFormat("UtcTime must be in ISO 8601 format")
        }
        self.value = date
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        try self.init(from: dateString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(toString())
    }
    
    public var description: String {
        return toString()
    }
    
    private func toString() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: value)
    }
}

public struct Mandate: JSONSerializable {
    public let epoch: Epoch
}

public struct NumberOfBytes: JSONSerializable {
    public let bytes: UInt64
}
