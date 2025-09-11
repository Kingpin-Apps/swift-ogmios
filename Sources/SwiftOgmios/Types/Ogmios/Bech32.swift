import Foundation

/// "A Blake2b 28-byte hash digest of a drep verification key or script.
public struct Bech32DRep: StringCallable {
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

