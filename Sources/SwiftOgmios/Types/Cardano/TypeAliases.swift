import Foundation

/// A block number, the i-th block to be minted is number i.
public typealias BlockHeight = UInt128

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

public struct Mandate: Codable, Sendable {
    public let epoch: Epoch
}

public struct NumberOfBytes: Codable, Sendable {
    public let bytes: UInt64
}
