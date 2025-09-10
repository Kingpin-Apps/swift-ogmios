// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let members = try? newJSONDecoder().decode(Members.self, from: jsonData)

import Foundation

// MARK: - Members
public struct Members: Codable, Sendable {
    public let type: ExtraneousRedeemersType
    public let items: UnknownConstitutionalCommitteeMember

    public init(type: ExtraneousRedeemersType, items: UnknownConstitutionalCommitteeMember) {
        self.type = type
        self.items = items
    }
}
