
/// A Blake2b 28-byte hash digest of a pool's verification key.
public struct StakePoolId: StringCallable {
    let value: String
    
    public init(_ value: String) throws {
        guard value.starts(with: "pool1") else {
            throw OgmiosError
                .invalidFormat("RewardAccount must start with 'pool1', got \(value)")
        }
        
        self.value = value
    }
}


