// MARK: - Ada
public struct Ada: JSONSerializable {
    /// An amount, possibly negative, in Lovelace (1e6 Lovelace = 1 Ada).
    public let lovelace: Int64
}

// MARK: - Value
public struct ValueAdaOnly: JSONSerializable {
    public let ada: Ada
}

public struct ValueDelta: JSONSerializable {
    public let ada: Ada
}
