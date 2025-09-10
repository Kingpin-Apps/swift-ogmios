import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateConstitution() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let constitutionHTTP = try await httpClient.ledgerStateQuery.constitution.execute(
        id: .number(httpClient.getNextRequestId())
    )
    let constitutionWS = try await wsClient.ledgerStateQuery.constitution.execute(
        id: .number(httpClient.getNextRequestId())
    )
    
    print("Constitution (HTTP): \(constitutionHTTP)")
    print("Constitution (WS): \(constitutionWS)")
}
