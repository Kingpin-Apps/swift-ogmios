import Foundation

/// "A Blake2b 28-byte hash digest of a drep verification key or script.
public struct Bech32DRep: Codable, Sendable {
    let root: String
    
    public init(_ root: String) throws {
        guard root.count == 56 else {
            throw OgmiosError
                .invalidLength(
                    "Bech32DRep must be exactly 56 characters, got \(root.count)"
                )
        }
        
        guard root.starts(with: "drep_vkh") || root.starts(with: "drep_script") else {
            throw OgmiosError
                .invalidFormat("Bech32DRep must start with 'drep_script' or 'drep_vkh', got \(root)")
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

