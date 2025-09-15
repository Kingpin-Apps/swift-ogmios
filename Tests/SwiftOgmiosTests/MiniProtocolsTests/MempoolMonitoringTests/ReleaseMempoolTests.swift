import Testing
@testable import SwiftOgmios

@Test func testReleaseMempool() async throws {
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
    
    let releaseMempoolHTTP = try await httpClient
        .mempoolMonitor
        .releaseMempool
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let releaseMempoolWS = try await wsClient
        .mempoolMonitor
        .releaseMempool
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(releaseMempoolHTTP.result.released == "mempool")
    #expect(releaseMempoolWS.result.released == "mempool")
}
