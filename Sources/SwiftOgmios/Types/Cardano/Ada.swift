import Foundation

// MARK: - Ada
public struct Ada: Codable, Sendable {
    /// An amount, possibly negative, in Lovelace (1e6 Lovelace = 1 Ada).
    public let lovelace: Int64
}
