/// An Ed25519 verification key.
public struct VerificationKey: StringCallable {
    public let value: String
    
    public init(_ value: String) throws {
        guard value.count == 64 else {
            throw OgmiosError
                .invalidLength(
                    "VerificationKey must be exactly 64 characters, got \(value.count)"
                )
        }
        
        self.value = value
    }
}
