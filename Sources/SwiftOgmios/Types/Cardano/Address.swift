
/// A stake address (a.k.a reward account)
public struct StakeAddress: StringCallable {
    public let value: String
    
    public init(_ value: String) throws {
        guard value.starts(with: "stake1") || value.starts(with: "stake_test1") else {
            throw OgmiosError
                .invalidFormat("RewardAccount must start with 'stake1' or 'stake_test1', got \(value)")
        }
        
        self.value = value
    }
}
