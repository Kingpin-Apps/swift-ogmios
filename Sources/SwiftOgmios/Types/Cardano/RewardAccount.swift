/// A reward account, also known as 'stake address'.
public struct RewardAccount: StringCallable, Codable, Sendable {
    public let value: String
    
    public init(_ value: String) throws {
        guard value.starts(with: "stake1") || value.starts(with: "stake_test1") else {
            throw OgmiosError
                .invalidFormat("RewardAccount must start with 'stake1' or 'stake_test1', got \(value)")
        }
        
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        try self.init(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public struct RewardTransfer: StringCallable {
    let value: Dictionary<String, ValueDelta>
    
    public init(_ value: Dictionary<String, ValueDelta>) throws {
        self.value = value
    }
}

