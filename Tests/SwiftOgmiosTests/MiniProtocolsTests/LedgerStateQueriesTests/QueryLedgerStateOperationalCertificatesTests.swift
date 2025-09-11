import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateOperationalCertificates() async throws {
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
    
    let operationalCertificatesHTTP = try await httpClient
        .ledgerStateQuery
        .operationalCertificates
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let operationalCertificatesWS = try await wsClient
        .ledgerStateQuery
        .operationalCertificates
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(operationalCertificatesHTTP.result.value.count == 6)
    #expect(operationalCertificatesWS.result.value.count == 6)
}
