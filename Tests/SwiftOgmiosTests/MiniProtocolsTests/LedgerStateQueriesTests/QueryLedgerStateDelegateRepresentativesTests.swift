import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateDelegateRepresentatives() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let delegateRepresentativesHTTP = try await httpClient
        .ledgerStateQuery
        .delegateRepresentatives
        .execute(
            id: .number(httpClient.getNextRequestId())
        )
    let delegateRepresentativesWS = try await wsClient
        .ledgerStateQuery
        .delegateRepresentatives
        .execute(
            id: .number(httpClient.getNextRequestId())
        )
    
    print("DelegateRepresentatives (HTTP): \(delegateRepresentativesHTTP)")
    print("DelegateRepresentatives (WS): \(delegateRepresentativesWS)")
}
