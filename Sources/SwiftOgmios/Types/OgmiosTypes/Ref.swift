import Foundation

public enum Ref: String, Codable, Sendable {
    case ogmiosJSONPropertiesAcquireLedgerStateFailure = "ogmios.json#/properties/AcquireLedgerStateFailure"
    case ogmiosJSONPropertiesMustAcquireMempoolFirst = "ogmios.json#/properties/MustAcquireMempoolFirst"
    case ogmiosJSONPropertiesQueryLedgerStateAcquiredExpired = "ogmios.json#/properties/QueryLedgerStateAcquiredExpired"
    case ogmiosJSONPropertiesQueryLedgerStateEraMismatch = "ogmios.json#/properties/QueryLedgerStateEraMismatch"
    case ogmiosJSONPropertiesQueryLedgerStateUnavailableInCurrentEra = "ogmios.json#/properties/QueryLedgerStateUnavailableInCurrentEra"
}
