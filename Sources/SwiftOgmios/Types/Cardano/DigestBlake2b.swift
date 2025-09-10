/// A Blake2b 32-byte hash digest, encoded in base16.
/// Example: "c248757d390181c517a5beadc9c3fe64bf821d3e889a963fc717003ec248757d"
public struct DigestBlake2b256: Codable, Hashable, Sendable {
    let root: String
    
    public init(_ root: String) throws {
        guard root.count == 64 else {
            throw OgmiosError
                .invalidLength(
                    "DigestBlake2b256 must be exactly 64 characters, got \(root.count)"
                )
        }
        
        guard root.allSatisfy({ $0.isHexDigit }) else {
            throw OgmiosError.invalidFormat("DigestBlake2b256 must contain only hexadecimal characters")
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

/// A Blake2b 28-byte hash digest, encoded in base16.
/// Example: "90181c517a5beadc9c3fe64bf821d3e889a963fc717003ec248757d3"
public struct DigestBlake2b224: Codable, Hashable, Sendable {
    let root: String
    
    public init(_ root: String) throws {
        guard root.count == 56 else {
            throw OgmiosError
                .invalidLength(
                    "DigestBlake2b224 must be exactly 56 characters, got \(root.count)"
                )
        }
        
        guard root.allSatisfy({ $0.isHexDigit }) else {
            throw OgmiosError.invalidFormat("DigestBlake2b224 must contain only hexadecimal characters")
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
