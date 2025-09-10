import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateEraSummaries() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let eraSummariesHTTP = try await httpClient.ledgerStateQuery.eraSummaries.execute(
        id: .number(httpClient.getNextRequestId())
    )
    let eraSummariesWS = try await wsClient.ledgerStateQuery.eraSummaries.execute(
        id: .number(httpClient.getNextRequestId())
    )
    
    print("EraSummaries (HTTP): \(eraSummariesHTTP)")
    print("EraSummaries (WS): \(eraSummariesWS)")
}


