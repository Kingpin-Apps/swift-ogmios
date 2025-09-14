import Testing
@testable import SwiftOgmios

@Test func testQueryEpoch() async throws {
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
    
    let epochHTTP = try await httpClient
        .ledgerStateQuery
        .epoch
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let epochWS = try await wsClient
        .ledgerStateQuery
        .epoch
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(epochHTTP.result == 1052)
    #expect(epochWS.result == 1052)
}
