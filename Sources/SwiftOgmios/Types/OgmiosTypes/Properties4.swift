// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties4 = try? newJSONDecoder().decode(Properties4.self, from: jsonData)

import Foundation

// MARK: - Properties4
public struct Properties4: Codable, Sendable {
    public let extraneousRedeemers: ExtraneousRedeemers

    public init(extraneousRedeemers: ExtraneousRedeemers) {
        self.extraneousRedeemers = extraneousRedeemers
    }
}
