@testable import SwiftOgmios
import Testing

@Test func testQueryLedgerStateConstitution() async throws {
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

    let constitutionHTTP = try await httpClient
        .ledgerStateQuery
        .constitution
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let constitutionWS = try await wsClient
        .ledgerStateQuery
        .constitution
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(
        constitutionHTTP.result.guardrails!.hash() == "fa24fb305126805cf2164c161d852a0e7330cf988f1fe558cf7d4a64"
    )
    #expect(
        constitutionWS.result.guardrails!.hash() == "fa24fb305126805cf2164c161d852a0e7330cf988f1fe558cf7d4a64"
    )
}
