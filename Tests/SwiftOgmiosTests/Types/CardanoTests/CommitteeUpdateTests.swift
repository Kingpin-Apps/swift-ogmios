import Foundation
import Testing
@testable import SwiftOgmios

@Suite("A committee update keeps the members it removes")
struct CommitteeUpdateTests {
    static let origins: [String] = ["verificationKey", "script"]

    @Test("A removed member decodes with its credential id and origin", arguments: origins)
    func removedMember(_ origin: String) throws {
        let removed = String(repeating: "ab", count: 28)
        let added = String(repeating: "cd", count: 28)
        let json = """
            {"type": "constitutionalCommittee",
             "members": {"added": [{"id": "\(added)", "from": "script", "mandate": {"epoch": 500}}],
                         "removed": [{"id": "\(removed)", "from": "\(origin)"}]},
             "quorum": "2/3"}
            """
        let action = try JSONDecoder().decode(GovernanceAction.self, from: Data(json.utf8))
        guard case .constitutionalCommittee(let update) = action else {
            Issue.record("Expected a committee update, got \(action)")
            return
        }
        let member = try #require(update.members.removed?.first)
        #expect(update.members.removed?.count == 1)
        #expect(member.id.value == removed)
        #expect(member.from.rawValue == origin)
        #expect(update.members.added?.first?.id.value == added)
    }

    @Test("A removed member without its id does not decode")
    func removedMemberNeedsID() {
        let json = #"{"type": "constitutionalCommittee", "members": {"added": [], "removed": [{"from": "script"}]}}"#
        #expect(throws: (any Error).self) { try JSONDecoder().decode(GovernanceAction.self, from: Data(json.utf8)) }
    }
}
