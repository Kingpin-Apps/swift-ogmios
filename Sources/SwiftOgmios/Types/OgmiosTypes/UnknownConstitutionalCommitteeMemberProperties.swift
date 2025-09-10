// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let unknownConstitutionalCommitteeMemberProperties = try? newJSONDecoder().decode(UnknownConstitutionalCommitteeMemberProperties.self, from: jsonData)

import Foundation

// MARK: - UnknownConstitutionalCommitteeMemberProperties
public struct UnknownConstitutionalCommitteeMemberProperties: Codable, Sendable {
    public let id, from: PropertyNames

    public init(id: PropertyNames, from: PropertyNames) {
        self.id = id
        self.from = from
    }
}
