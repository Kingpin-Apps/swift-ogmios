import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateProjectedRewards() async throws {
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
    
    let projectedRewardsHTTP = try await httpClient
        .ledgerStateQuery
        .projectedRewards
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: QueryLedgerStateProjectedRewards.Params(
                stake: [ValueAdaOnly(ada: Ada(lovelace: 1_000_000))],
                scripts: [],
                keys: []
            )
            
        )
    let projectedRewardsWS = try await wsClient
        .ledgerStateQuery
        .projectedRewards
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: QueryLedgerStateProjectedRewards.Params(
                stake: [ValueAdaOnly(ada: Ada(lovelace: 1_000_000))],
                scripts: [],
                keys: []
            )
        )
    
    #expect(projectedRewardsHTTP.id == projectedRewardsWS.id)
    
    switch projectedRewardsHTTP.result {
        case .credentials(let credentialsData):
            #expect(credentialsData.value.count > 0)
        case .lovelaces(let lovelacesData):
            #expect(lovelacesData.value.count > 0)
    }
    
    switch projectedRewardsWS.result {
        case .credentials(let credentialsData):
            #expect(credentialsData.value.count > 0)
        case .lovelaces(let lovelacesData):
            #expect(lovelacesData.value.count > 0)
    }
    
}
