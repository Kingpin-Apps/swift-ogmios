import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateConstitutionalCommittee() async throws {
    let mockHTTPConnection = MockHTTPConnection()
    let mockWebSocketConnection = MockWebSocketConnection()
    
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: mockHTTPConnection
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: mockWebSocketConnection
    )
    
    let constitutionalCommitteeHTTP = try await httpClient
        .ledgerStateQuery
        .constitutionalCommittee
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let constitutionalCommitteenWS = try await wsClient
        .ledgerStateQuery
        .constitutionalCommittee
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(constitutionalCommitteeHTTP.result.members.count == 1)
    #expect(constitutionalCommitteenWS.result.members.count == 1)
    
    #expect(constitutionalCommitteeHTTP.result.quorum!() == "2/3")
    #expect(constitutionalCommitteenWS.result.quorum!() == "2/3")
}
