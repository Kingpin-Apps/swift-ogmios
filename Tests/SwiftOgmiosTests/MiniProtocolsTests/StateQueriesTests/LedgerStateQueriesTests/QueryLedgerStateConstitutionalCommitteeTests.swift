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
        .result(
            id: JSONRPCId.generateNextNanoId()
        )
    let constitutionalCommitteenWS = try await wsClient
        .ledgerStateQuery
        .constitutionalCommittee
        .result(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(constitutionalCommitteeHTTP.members.count == 1)
    #expect(constitutionalCommitteenWS.members.count == 1)
    
    #expect(constitutionalCommitteeHTTP.quorum!() == "2/3")
    #expect(constitutionalCommitteenWS.quorum!() == "2/3")
}
