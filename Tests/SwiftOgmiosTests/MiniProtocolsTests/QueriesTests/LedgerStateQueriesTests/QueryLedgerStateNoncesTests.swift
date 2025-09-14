import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateNonces() async throws {
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
    
    let noncesHTTP = try await httpClient
        .ledgerStateQuery
        .nonces
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let noncesWS = try await wsClient
        .ledgerStateQuery
        .nonces
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(noncesHTTP.result.evolvingNonce() == "72714536007d2def6a7a1b79bd17592543f3efb90e9aa13141112c32eb4b9212")
    #expect(noncesWS.result.evolvingNonce() == "72714536007d2def6a7a1b79bd17592543f3efb90e9aa13141112c32eb4b9212")
}
