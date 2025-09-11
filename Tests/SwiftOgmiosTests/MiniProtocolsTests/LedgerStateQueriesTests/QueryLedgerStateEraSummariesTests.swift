import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateEraSummaries() async throws {
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
    
    let eraSummariesHTTP = try await httpClient
        .ledgerStateQuery
        .eraSummaries
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let eraSummariesWS = try await wsClient
        .ledgerStateQuery
        .eraSummaries
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(eraSummariesHTTP.result.count == 1)
    #expect(eraSummariesWS.result.count == 1)
}


