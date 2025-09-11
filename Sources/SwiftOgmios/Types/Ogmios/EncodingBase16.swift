import Foundation

/// A key or script hash in base16.
public struct EncodingBase16: StringCallable {
    let value: String
    
    public init(_ value: String) throws {
        guard value.count == 56 else {
            throw OgmiosError
                .invalidLength(
                    "EncodingBase16 must be exactly 56 characters, got \(value.count)"
                )
        }
        
        self.value = value
    }
    
    // For JSON decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let valueValue = try container.decode(String.self)
        try self.init(valueValue)
    }
    
    // For JSON encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
