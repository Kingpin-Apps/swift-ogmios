import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateDelegateRepresentatives() async throws {
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
    
    let delegateRepresentativesHTTP = try await httpClient
        .ledgerStateQuery
        .delegateRepresentatives
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let delegateRepresentativesWS = try await wsClient
        .ledgerStateQuery
        .delegateRepresentatives
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(delegateRepresentativesHTTP.result.count == 3)
    #expect(delegateRepresentativesWS.result.count == 3)
}
