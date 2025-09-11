
/// An epoch number or length.
public typealias Epoch = UInt64

/// An absolute slot number.
public typealias Slot = UInt64

/// A hash digest from an unspecified algorithm and length.
public typealias DigestAny = String

/// Number of slots from the tip of the ledger in which it is guaranteed that no hard fork can take place.
/// This should be (at least) the number of slots in which we are guaranteed to have k blocks.
public typealias SafeZone = UInt64

public enum CredentialOrigin : String, Codable, Hashable, Sendable {
    case verificationKey
    case script
}

public struct Delegators: Codable, Sendable {
    public let credential: DigestBlake2b224
    public let from: CredentialOrigin
}

public struct Members: Codable, Sendable {
    public let id: DigestBlake2b224
    public let from: CredentialOrigin
}

public struct EpochWrapper: Codable, Sendable {
    public let epoch: Epoch
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

public struct Mandate: Codable, Sendable {
    public let epoch: Epoch
}

public struct NumberOfBytes: Codable, Sendable {
    public let bytes: UInt64
}
