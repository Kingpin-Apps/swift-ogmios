import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateConstitutionalCommittee() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let constitutionalCommitteeHTTP = try await httpClient
        .ledgerStateQuery
        .constitutionalCommittee
        .execute(
            id: .number(httpClient.getNextRequestId())
        )
    let constitutionalCommitteenWS = try await wsClient
        .ledgerStateQuery
        .constitutionalCommittee
        .execute(
            id: .number(httpClient.getNextRequestId())
        )
    
    print("ConstitutionalCommittee (HTTP): \(constitutionalCommitteeHTTP)")
    print("ConstitutionalCommittee (WS): \(constitutionalCommitteenWS)")
}
