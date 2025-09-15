
public struct BytesWrapper: JSONSerializable {
    public let bytes: UInt128
}

public struct CountWrapper: JSONSerializable {
    public let count: UInt64
}

public struct EpochWrapper: JSONSerializable {
    public let epoch: Epoch
}

public struct TransactionIdWrapper: JSONSerializable {
    public let id: String
    
    public init(_ id: String) throws {
        guard id.count == 64 else {
            throw OgmiosError
                .invalidLength(
                    "TransactionId must be exactly 64 characters, got \(id.count)"
                )
        }
        
        self.id = id
    }
}
