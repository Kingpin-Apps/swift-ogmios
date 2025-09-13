// MARK: - Ada
public struct Ada: Codable, Sendable, Equatable, Hashable {
    /// An amount, possibly negative, in Lovelace (1e6 Lovelace = 1 Ada).
    public let lovelace: Int64
}

// MARK: - Value
public struct ValueAdaOnly: JSONSerializable, Sendable, Equatable, Hashable {
    public let ada: Ada
}

public struct ValueDelta: JSONSerializable, Sendable, Equatable, Hashable {
    public let ada: Ada
}
