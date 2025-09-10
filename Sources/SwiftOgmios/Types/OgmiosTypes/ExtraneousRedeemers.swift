// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let extraneousRedeemers = try? newJSONDecoder().decode(ExtraneousRedeemers.self, from: jsonData)

import Foundation

// MARK: - ExtraneousRedeemers
public struct ExtraneousRedeemers: Codable, Sendable {
    public let type: ExtraneousRedeemersType
    public let items: PropertyNames

    public init(type: ExtraneousRedeemersType, items: PropertyNames) {
        self.type = type
        self.items = items
    }
}
