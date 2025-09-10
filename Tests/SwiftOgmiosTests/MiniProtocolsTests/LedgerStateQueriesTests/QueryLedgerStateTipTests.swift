import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateTip() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let ledgerTipHTTP = try await httpClient.ledgerStateQuery.tip.execute(
        id: .number(httpClient.getNextRequestId())
    )
    let ledgerTipWS = try await wsClient.ledgerStateQuery.tip.execute(
        id: .number(httpClient.getNextRequestId())
    )
    
    print("Tip (HTTP): \(ledgerTipHTTP)")
    print("Tip (WS): \(ledgerTipWS)")
}
