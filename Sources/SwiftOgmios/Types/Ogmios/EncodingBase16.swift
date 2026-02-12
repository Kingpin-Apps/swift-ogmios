import Foundation

/// A key or script hash in base16.
public struct EncodingBase16: StringCallable {
    public let value: String
    
    public init(_ value: String) throws {
        guard value.count == 56 else {
            throw OgmiosError
                .invalidLength(
                    "EncodingBase16 must be exactly 56 characters, got \(value.count)"
                )
        }
        
        self.value = value
    }
}
