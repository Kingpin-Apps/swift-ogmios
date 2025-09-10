// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties2 = try? newJSONDecoder().decode(Properties2.self, from: jsonData)

import Foundation

// MARK: - Properties2
public struct Properties2: Codable, Sendable {
    public let proposal, voter: PropertyNames

    public init(proposal: PropertyNames, voter: PropertyNames) {
        self.proposal = proposal
        self.voter = voter
    }
}
