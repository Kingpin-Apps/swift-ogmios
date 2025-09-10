import Foundation

/// Summary of the confirmed parts of the ledger.
public struct EraSummary: Codable, Sendable {
    public let start: Bound
    public let end: Bound?
    public let parameters: EraParameters
}

/// Parameters that can vary across hard forks.
public struct EraParameters: Codable, Sendable {
    public let epochLength: Epoch
    public let slotLength: SlotLength
    public let safeZone: SafeZone?
}
