// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fluffyResult = try? newJSONDecoder().decode(FluffyResult.self, from: jsonData)

import Foundation

// MARK: - FluffyResult
public struct FluffyResult: Codable, Sendable {
    public let type: ExtraneousRedeemersType
    public let items: ResultItems

    public init(type: ExtraneousRedeemersType, items: ResultItems) {
        self.type = type
        self.items = items
    }
}
