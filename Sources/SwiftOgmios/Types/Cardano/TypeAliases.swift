
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

/// A ratio of two integers, to express exact fractions.
public struct Ratio: Codable, Hashable, Sendable {
    let root: String
    
    public init(_ root: String) throws {
        guard root.split(separator: "/").count == 2 else {
            throw OgmiosError.invalidFormat("Ratio must be in the format 'numerator/denominator'")
        }
                      
        self.root = root
    }
    
    // For JSON decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rootValue = try container.decode(String.self)
        try self.init(rootValue)
    }
    
    // For JSON encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(root)
    }
}

public struct Mandate: Codable, Sendable {
    public let epoch: Epoch
}
