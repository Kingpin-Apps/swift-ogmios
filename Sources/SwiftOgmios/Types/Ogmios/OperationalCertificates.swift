import Foundation

/// Operational certificate counters from operating stake pools.
public struct OperationalCertificates: StringCallable {
    public let value: Dictionary<StakePoolId, Int>
    
    public init(_ value: Dictionary<StakePoolId, Int>) throws {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // Explicitly decode as dictionary, not array
        if let dictValue = try? container.decode([String: Int].self) {
            // Convert string keys to StakePoolId
            let converted = try Dictionary(uniqueKeysWithValues:
                                            dictValue.map { key, value in
                (try StakePoolId(key), value)
            }
            )
            try self.init(converted)
        } else {
            throw DecodingError.typeMismatch(
                Dictionary<StakePoolId, Int>.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected dictionary but found different type"
                )
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let stringDict = Dictionary(uniqueKeysWithValues:
            value.map { key, value in
                (key.value, value)
            }
        )
        try container.encode(stringDict)
    }
}
