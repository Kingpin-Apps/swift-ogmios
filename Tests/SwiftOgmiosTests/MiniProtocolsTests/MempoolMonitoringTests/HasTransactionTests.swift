import Testing
@testable import SwiftOgmios

@Test func testHasTransaction() async throws {
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
    
    let hasTransactionHTTP = try await httpClient
        .mempoolMonitor
        .hasTransaction
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init("a3edaf9627d81c28a51a729b370f97452f485c70b8ac9dca15791e0ae26618ae")
        )
    let hasTransactionWS = try await wsClient
        .mempoolMonitor
        .hasTransaction
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init("a3edaf9627d81c28a51a729b370f97452f485c70b8ac9dca15791e0ae26618ae")
        )
    
    #expect(hasTransactionHTTP.result == true)
    #expect(hasTransactionWS.result == true)
}
