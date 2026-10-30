import Foundation
import Testing
@testable import SwiftOgmios

@Test func testDecodeAbstainDelegateRepresentative() throws {
    let json = #"{"type":"abstain","stake":{"ada":{"lovelace":46115228289209}}}"#
    let summary = try DelegateRepresentativeSummary.fromJSONString(json)

    guard case .abstain(let abstain) = summary else {
        Issue.record("Expected .abstain, got \(summary.description)")
        return
    }
    #expect(abstain.type == "abstain")
    #expect(abstain.stake.ada.lovelace == 46115228289209)
}

@Test func testDecodeNoConfidenceDelegateRepresentative() throws {
    let json = #"{"type":"noConfidence","stake":{"ada":{"lovelace":15049380877790}}}"#
    let summary = try DelegateRepresentativeSummary.fromJSONString(json)

    guard case .noConfidence(let noConfidence) = summary else {
        Issue.record("Expected .noConfidence, got \(summary.description)")
        return
    }
    #expect(noConfidence.type == "noConfidence")
    #expect(noConfidence.stake.ada.lovelace == 15049380877790)
}

@Test func testDecodeDelegateRepresentativesMockKeepsEachKind() throws {
    struct Envelope: Decodable {
        let result: [DelegateRepresentativeSummary]
    }
    let decoded = try JSONDecoder().decode(Envelope.self, from: mockDelegateRepresentatives)
    let kinds = decoded.result.map(\.description)

    #expect(kinds.filter { $0 == "abstain" }.count == 1)
    #expect(kinds.filter { $0 == "noConfidence" }.count == 1)
    #expect(kinds.filter { $0 == "registered" }.count == 1)
}

@Test func testDecodeUnknownDelegateRepresentativeTypeFails() {
    let json = #"{"type":"bogus","stake":{"ada":{"lovelace":1}}}"#
    #expect(throws: DecodingError.self) {
        _ = try DelegateRepresentativeSummary.fromJSONString(json)
    }
}
