import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateGovernanceProposals() async throws {
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
    
    let governanceProposalsHTTP = try await httpClient
        .ledgerStateQuery
        .governanceProposals
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let governanceProposalsWS = try await wsClient
        .ledgerStateQuery
        .governanceProposals
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(governanceProposalsHTTP.result.count == 1)
    #expect(governanceProposalsWS.result.count == 1)
}
