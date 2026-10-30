// MARK: - Ada
/// A non-negative amount of Lovelace (1e6 Lovelace = 1 Ada), the ledger's `Coin`.
///
/// Decoded exactly over the full `0...UInt64.max` range; a negative or larger
/// amount fails to decode rather than being truncated.
public struct Ada: JSONSerializable {
    public let lovelace: UInt64

    public init(lovelace: UInt64) {
        self.lovelace = lovelace
    }
}

/// A signed amount of Lovelace, used where the ledger reports a delta
/// (e.g. reward transfers between pots, collateral balances in failures).
public struct AdaDelta: JSONSerializable {
    /// An amount, possibly negative, in Lovelace (1e6 Lovelace = 1 Ada).
    public let lovelace: Int64

    public init(lovelace: Int64) {
        self.lovelace = lovelace
    }
}

// MARK: - Value
public struct ValueAdaOnly: JSONSerializable {
    public let ada: Ada

    public init(ada: Ada) {
        self.ada = ada
    }
}

public struct ValueDelta: JSONSerializable {
    public let ada: AdaDelta

    public init(ada: AdaDelta) {
        self.ada = ada
    }
}
