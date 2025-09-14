/// A Blake2b 32-byte hash digest, encoded in base16.
/// Example: "c248757d390181c517a5beadc9c3fe64bf821d3e889a963fc717003ec248757d"
public struct DigestBlake2b256: StringCallable {
    let value: String
    
    public init(_ value: String) throws {
        guard value.count == 64 else {
            throw OgmiosError
                .invalidLength(
                    "DigestBlake2b256 must be exactly 64 characters, got \(value.count)"
                )
        }
        
        guard value.allSatisfy({ $0.isHexDigit }) else {
            throw OgmiosError.invalidFormat("DigestBlake2b256 must contain only hexadecimal characters")
        }
        
        self.value = value
    }
}

/// A Blake2b 28-byte hash digest, encoded in base16.
/// Example: "90181c517a5beadc9c3fe64bf821d3e889a963fc717003ec248757d3"
public struct DigestBlake2b224: StringCallable {
    let value: String
    
    public init(_ value: String) throws {
        guard value.count == 56 else {
            throw OgmiosError
                .invalidLength(
                    "DigestBlake2b224 must be exactly 56 characters, got \(value.count)"
                )
        }
        
        guard value.allSatisfy({ $0.isHexDigit }) else {
            throw OgmiosError.invalidFormat("DigestBlake2b224 must contain only hexadecimal characters")
        }
        
        self.value = value
    }
}


public struct Guardrails: JSONSerializable {
    public let hash: DigestBlake2b224
}
