import Foundation

/// "A Blake2b 28-byte hash digest of a drep verification key or script.
public struct Bech32: StringCallable {
    let value: String
    
    public init(_ value: String) throws {
        let pattern = "^(?:[0-9]+|[0-9a-f]+)$"
        guard value.range(of: pattern, options: .regularExpression) != nil else {
            throw OgmiosError.invalidFormat(
                "Bech32 value must match pattern \(pattern), got \(value)"
            )
        }
        
        self.value = value
    }
}

/// "A Blake2b 28-byte hash digest of a drep verification key or script.
public struct Bech32DRepVkhDRepScript: StringCallable {
    let value: String
    
    public init(_ value: String) throws {
        guard value.count == 56 else {
            throw OgmiosError
                .invalidLength(
                    "Bech32DRep must be exactly 56 characters, got \(value.count)"
                )
        }
        
        guard value.starts(with: "drep_vkh") || value.starts(with: "drep_script") else {
            throw OgmiosError
                .invalidFormat("Bech32DRep must start with 'drep_script' or 'drep_vkh', got \(value)")
        }
        
        self.value = value
    }
}

/// A Blake2b 28-byte hash digest of a verification key or script.
/// Examples: "script1dss9g887v3rdmadpq3n44d5ph3ma4aha2rtxfdsnnftykaau8x7",
///  "stake_vkh1dss9g887v3rdmadpq3n44d5ph3ma4aha2rtxfdsnnftyklueu8u"
public struct Bech32StakeVkhScript: StringCallable {
    let value: String
    
    public init(_ value: String) throws {
        guard value.starts(with: "stake_vkh") || value.starts(with: "script") else {
            throw OgmiosError
                .invalidFormat("Bech32StakeVkhScript must start with 'stake_vkh' or 'script', got \(value)")
        }
        
        self.value = value
    }
}

