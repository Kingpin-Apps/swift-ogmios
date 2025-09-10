// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties12 = try? newJSONDecoder().decode(Properties12.self, from: jsonData)

import Foundation

// MARK: - Properties12
public struct Properties12: Codable, Sendable {
    public let acquired: Jsonrpc?
    public let point, slot: PropertyNames?
    public let transaction: FluffyTransaction?
    public let treasury, reserves: PropertyNames?
    public let released: Jsonrpc?

    public init(acquired: Jsonrpc?, point: PropertyNames?, slot: PropertyNames?, transaction: FluffyTransaction?, treasury: PropertyNames?, reserves: PropertyNames?, released: Jsonrpc?) {
        self.acquired = acquired
        self.point = point
        self.slot = slot
        self.transaction = transaction
        self.treasury = treasury
        self.reserves = reserves
        self.released = released
    }
}
