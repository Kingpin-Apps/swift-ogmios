import Foundation

/// A pointer to an off-chain document: its URL and the hash of its content.
public struct Anchor: JSONSerializable {
    public let hash: DigestAny
    /// The URL exactly as written on chain. The ledger accepts any text, and
    /// the hash is checked against the document it names, so it is kept as
    /// text rather than parsed into a Foundation `URL`, which would refuse
    /// some and rewrite others.
    public let url: String
}
