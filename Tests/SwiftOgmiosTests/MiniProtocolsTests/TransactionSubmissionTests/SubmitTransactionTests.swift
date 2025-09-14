import Testing
@testable import SwiftOgmios

@Test func testSubmitTransaction() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let submitTransactionHTTP = try await httpClient
        .transactionSubmission
        .submitTransaction
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(
                transaction: .init(cbor: "8620")
            )
        )
    let submitTransactionWS = try await wsClient
        .transactionSubmission
        .submitTransaction
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(
                transaction: .init(cbor: "8620")
            )
        )
    
    #expect(submitTransactionHTTP.result.transaction.id == "a3edaf9627d81c28a51a729b370f97452f485c70b8ac9dca15791e0ae26618ae")
    #expect(submitTransactionWS.result.transaction.id == "a3edaf9627d81c28a51a729b370f97452f485c70b8ac9dca15791e0ae26618ae")
}
