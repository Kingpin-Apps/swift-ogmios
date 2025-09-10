// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let unknownConstitutionalCommitteeMember = try? newJSONDecoder().decode(UnknownConstitutionalCommitteeMember.self, from: jsonData)

import Foundation

// MARK: - UnknownConstitutionalCommitteeMember
public struct UnknownConstitutionalCommitteeMember: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let additionalProperties: Bool
    public let unknownConstitutionalCommitteeMemberRequired: [String]
    public let properties: UnknownConstitutionalCommitteeMemberProperties

    public enum CodingKeys: String, CodingKey {
        case type, additionalProperties
        case unknownConstitutionalCommitteeMemberRequired = "required"
        case properties
    }

    public init(type: DeserialisationFailureType, additionalProperties: Bool, unknownConstitutionalCommitteeMemberRequired: [String], properties: UnknownConstitutionalCommitteeMemberProperties) {
        self.type = type
        self.additionalProperties = additionalProperties
        self.unknownConstitutionalCommitteeMemberRequired = unknownConstitutionalCommitteeMemberRequired
        self.properties = properties
    }
}
