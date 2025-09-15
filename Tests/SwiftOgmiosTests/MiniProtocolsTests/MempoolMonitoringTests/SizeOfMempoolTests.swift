import Testing
@testable import SwiftOgmios

@Test func testSizeOfMempool() async throws {
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
    
    let sizeOfMempoolHTTP = try await httpClient
        .mempoolMonitor
        .sizeOfMempool
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let sizeOfMempoolWS = try await wsClient
        .mempoolMonitor
        .sizeOfMempool
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(sizeOfMempoolHTTP.result.maxCapacity.bytes == 18446744073709552000)
    #expect(sizeOfMempoolWS.result.maxCapacity.bytes == 18446744073709552000)
}
