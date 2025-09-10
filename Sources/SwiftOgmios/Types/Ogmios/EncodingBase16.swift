import Foundation

/// A key or script hash in base16.
public struct EncodingBase16: Codable, Sendable {
    let root: String
    
    public init(_ root: String) throws {
        guard root.count == 56 else {
            throw OgmiosError
                .invalidLength(
                    "EncodingBase16 must be exactly 56 characters, got \(root.count)"
                )
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
