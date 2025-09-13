import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateTreasuryAndReserves() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let treasuryAndReservesHTTP = try await httpClient
        .ledgerStateQuery
        .treasuryAndReserves
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let treasuryAndReservesWS = try await wsClient
        .ledgerStateQuery
        .treasuryAndReserves
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(treasuryAndReservesHTTP.result.treasury.ada.lovelace == 5891303965843822)
    #expect(treasuryAndReservesHTTP.result.reserves.ada.lovelace == 8930635913557279)
    
    #expect(treasuryAndReservesWS.result.treasury.ada.lovelace == 5891303965843822)
    #expect(treasuryAndReservesWS.result.reserves.ada.lovelace == 8930635913557279)
}
