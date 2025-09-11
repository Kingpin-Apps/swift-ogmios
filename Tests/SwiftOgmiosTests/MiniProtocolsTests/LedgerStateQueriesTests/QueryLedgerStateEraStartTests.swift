import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateEraStart() async throws {
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
    
    let eraStartHTTP = try await httpClient
        .ledgerStateQuery
        .eraStart
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let eraStartpWS = try await wsClient
        .ledgerStateQuery
        .eraStart
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(eraStartHTTP.result.slot == 55814400)
    #expect(eraStartpWS.result.slot == 55814400)
}
