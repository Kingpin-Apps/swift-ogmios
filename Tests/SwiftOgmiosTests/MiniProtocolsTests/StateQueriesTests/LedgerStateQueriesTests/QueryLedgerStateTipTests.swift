import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateTip() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let ledgerTipHTTP = try await httpClient
        .ledgerStateQuery
        .tip
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let ledgerTipWS = try await wsClient
        .ledgerStateQuery
        .tip
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    guard case let .point(pointHTTP) = ledgerTipHTTP.result else {
        Issue.record("Expected ledger tip to be of type .point")
        return
    }
    guard case let .point(pointWS) = ledgerTipWS.result else {
        Issue.record("Expected ledger tip to be of type .point")
        return
    }
    
    #expect(pointHTTP.slot == 90918798)
    #expect(pointWS.slot == 90918798)
}
