import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateEraStart() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let eraStartHTTP = try await httpClient.ledgerStateQuery.eraStart.execute(
        id: .number(httpClient.getNextRequestId())
    )
    let eraStartpWS = try await wsClient.ledgerStateQuery.eraStart.execute(
        id: .number(httpClient.getNextRequestId())
    )
    
    print("EraStart (HTTP): \(eraStartHTTP)")
    print("EraStart (WS): \(eraStartpWS)")
}
