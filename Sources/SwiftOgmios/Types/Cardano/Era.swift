import Foundation

public enum Era: String, Codable, Sendable {
    case byron
    case shelley
    case allegra
    case mary
    case alonzo
    case babbage
    case conway
}

public enum EraWithGenesis: String, Codable, Sendable, CaseIterable {
    case byron
    case shelley
    case alonzo
    case conway
}

public struct EraWrapper: Codable, Sendable {
    public let era: Era
}

public struct EraWithGenesisWrapper: Codable, Sendable {
    public let era: EraWithGenesis
}

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
