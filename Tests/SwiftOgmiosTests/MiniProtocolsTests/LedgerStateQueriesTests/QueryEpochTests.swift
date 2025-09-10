import Testing
@testable import SwiftOgmios

@Test func testQueryEpoch() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let epochHTTP = try await httpClient.ledgerStateQuery.epoch.execute(
        id: .number(httpClient.getNextRequestId())
    )
    let epochWS = try await wsClient.ledgerStateQuery.epoch.execute(
        id: .number(httpClient.getNextRequestId())
    )
    
    print("Epoch (HTTP): \(epochHTTP))")
    print("Epoch (WS): \(epochWS)")
}
