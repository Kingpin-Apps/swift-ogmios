import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateStakePools() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let stakePoolsHTTP = try await httpClient
        .ledgerStateQuery
        .stakePools
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let stakePoolsWS = try await wsClient
        .ledgerStateQuery
        .stakePools
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(stakePoolsHTTP.result.count == 2)
    #expect(stakePoolsWS.result.count == 2)
    
    // Test first pool
    let firstPoolId = try StakePoolId("pool1qqa8tkycj4zck4sy7n8mqr22x5g7tvm8hnp9st95wmuvvtw28th")
    let firstPool = stakePoolsHTTP.result[firstPoolId]
    
    #expect(firstPool != nil)
    #expect(firstPool?.id == firstPoolId)
    #expect(firstPool?.cost.ada.lovelace == 340000000)
    #expect(firstPool?.margin.value == "0/1")
    #expect(firstPool?.pledge.ada.lovelace == 500000000)
    #expect(firstPool?.stake?.ada.lovelace == 13492420330)
    #expect(firstPool?.owners.count == 1)
    #expect(firstPool?.relays.count == 1)
    #expect(firstPool?.metadata != nil)
    #expect(firstPool?.metadata?.url.absoluteString == "https://example.com/pool-metadata.json")
    
    // Test second pool (without stake)
    let secondPoolId = try StakePoolId("pool1qzq896ke4meh0tn9fl0dcnvtn2rzdz75lk3h8nmsuew8z5uln7r")
    let secondPool = stakePoolsHTTP.result[secondPoolId]
    
    #expect(secondPool != nil)
    #expect(secondPool?.id == secondPoolId)
    #expect(secondPool?.cost.ada.lovelace == 170000000)
    #expect(secondPool?.margin.value == "1/100")
    #expect(secondPool?.pledge.ada.lovelace == 1000000000)
    #expect(secondPool?.stake == nil) // This pool doesn't have stake in the mock data
    #expect(secondPool?.metadata == nil) // This pool doesn't have metadata in the mock data
}
