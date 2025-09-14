import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateProtocolParameters() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let protocolParametersHTTP = try await httpClient
        .ledgerStateQuery
        .protocolParameters
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let protocolParametersWS = try await wsClient
        .ledgerStateQuery
        .protocolParameters
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(protocolParametersHTTP.result.minFeeCoefficient == 44)
    #expect(protocolParametersWS.result.minFeeCoefficient == 44)
}
