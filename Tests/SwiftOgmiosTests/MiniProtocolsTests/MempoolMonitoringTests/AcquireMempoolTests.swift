import Testing
@testable import SwiftOgmios

@Test func testAcquireMempool() async throws {
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
    
    let acquireMempoolHTTP = try await httpClient
        .mempoolMonitor
        .acquireMempool
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let acquireMempoolWS = try await wsClient
        .mempoolMonitor
        .acquireMempool
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(acquireMempoolHTTP.result.acquired == "mempool")
    #expect(acquireMempoolWS.result.acquired == "mempool")
    
    #expect(acquireMempoolHTTP.result.slot == 91232958)
    #expect(acquireMempoolWS.result.slot == 91232958)
}



