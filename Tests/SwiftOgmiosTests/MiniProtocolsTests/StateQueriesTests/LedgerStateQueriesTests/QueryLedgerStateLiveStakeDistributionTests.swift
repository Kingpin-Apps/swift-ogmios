import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateLiveStakeDistribution() async throws {
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
    
    let liveStakeDistributionHTTP = try await httpClient
        .ledgerStateQuery
        .liveStakeDistribution
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let liveStakeDistributionWS = try await wsClient
        .ledgerStateQuery
        .liveStakeDistribution
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(liveStakeDistributionHTTP.result.value.count == 3)
    #expect(liveStakeDistributionWS.result.value.count == 3)
}


