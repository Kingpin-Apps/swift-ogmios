import Testing
@testable import SwiftOgmios

@Test func testEvaluateTransaction() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let evaluateTransactionHTTP = try await httpClient
        .transactionSubmission
        .evaluateTransaction
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(
                transaction: .init(cbor: "8620")
            )
        )
    let evaluateTransactionWS = try await wsClient
        .transactionSubmission
        .evaluateTransaction
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(
                transaction: .init(cbor: "8620")
            )
        )
    
    #expect(evaluateTransactionHTTP.result.count == 2)
    #expect(evaluateTransactionWS.result.count == 2)
}
