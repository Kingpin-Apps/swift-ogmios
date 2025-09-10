// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let invalidOrMissingPreviousProposals = try? newJSONDecoder().decode(InvalidOrMissingPreviousProposals.self, from: jsonData)

import Foundation

// MARK: - InvalidOrMissingPreviousProposals
public struct InvalidOrMissingPreviousProposals: Codable, Sendable {
    public let type: ExtraneousRedeemersType
    public let items: InvalidOrMissingPreviousProposalsItems

    public init(type: ExtraneousRedeemersType, items: InvalidOrMissingPreviousProposalsItems) {
        self.type = type
        self.items = items
    }
}
