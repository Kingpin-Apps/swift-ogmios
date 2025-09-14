import Testing
@testable import SwiftOgmios

@Test func testNextTransaction() async throws {
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
    
    let nextTransactionHTTP = try await httpClient
        .mempoolMonitor
        .nextTransaction
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let nextTransactionWS = try await wsClient
        .mempoolMonitor
        .nextTransaction
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    if case let .transactionId(txId) = nextTransactionHTTP.result.transaction {
        #expect(txId.id == "a3edaf9627d81c28a51a729b370f97452f485c70b8ac9dca15791e0ae26618ae")
    } else {
        Issue.record("Expected transactionId case")
        return
    }
    
    if case let .transactionId(txId) = nextTransactionWS.result.transaction {
        #expect(txId.id == "a3edaf9627d81c28a51a729b370f97452f485c70b8ac9dca15791e0ae26618ae")
    } else {
        Issue.record("Expected transactionId case")
        return
    }
}
