import Foundation

public enum Era: String, JSONSerializable {
    case byron
    case shelley
    case allegra
    case mary
    case alonzo
    case babbage
    case conway
}

public enum EraWithGenesis: String, CaseIterable, JSONSerializable {
    case byron
    case shelley
    case alonzo
    case conway
}

public struct EraWrapper: JSONSerializable {
    public let era: Era
}

public struct EraWithGenesisWrapper: JSONSerializable {
    public let era: EraWithGenesis
}

/// Summary of the confirmed parts of the ledger.
public struct EraSummary: JSONSerializable {
    public let start: Bound
    public let end: Bound?
    public let parameters: EraParameters
}

/// Parameters that can vary across hard forks.
public struct EraParameters: JSONSerializable {
    public let epochLength: Epoch
    public let slotLength: SlotLength
    public let safeZone: SafeZone?
}
