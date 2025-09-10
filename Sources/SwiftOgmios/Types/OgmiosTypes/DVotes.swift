// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dVotes = try? newJSONDecoder().decode(DVotes.self, from: jsonData)

import Foundation

// MARK: - DVotes
public struct DVotes: Codable, Sendable {
    public let type: ExtraneousRedeemersType
    public let items: InvalidVotesItems

    public init(type: ExtraneousRedeemersType, items: InvalidVotesItems) {
        self.type = type
        self.items = items
    }
}
