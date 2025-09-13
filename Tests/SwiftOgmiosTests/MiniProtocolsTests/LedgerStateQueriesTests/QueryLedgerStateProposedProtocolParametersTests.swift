import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateProposedProtocolParameters() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let proposedProtocolParametersHTTP = try await httpClient
        .ledgerStateQuery
        .proposedProtocolParameters
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let proposedProtocolParametersWS = try await wsClient
        .ledgerStateQuery
        .proposedProtocolParameters
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    // The result is an array of proposed protocol parameters
    // In the test case, we expect at least one proposed protocol parameter
    #expect(!proposedProtocolParametersHTTP.result.isEmpty)
    #expect(!proposedProtocolParametersWS.result.isEmpty)
    
    // Check the first proposed protocol parameter
    #expect(proposedProtocolParametersHTTP.result[0].minFeeCoefficient == 18446744073709552)
    #expect(proposedProtocolParametersWS.result[0].minFeeCoefficient == 18446744073709552)
}


