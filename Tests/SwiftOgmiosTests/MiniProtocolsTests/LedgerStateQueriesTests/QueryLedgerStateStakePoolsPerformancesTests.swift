import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateStakePoolsPerformances() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let stakePoolsPerformancesHTTP = try await httpClient
        .ledgerStateQuery
        .stakePoolsPerformances
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let stakePoolsPerformancesWS = try await wsClient
        .ledgerStateQuery
        .stakePoolsPerformances
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(stakePoolsPerformancesHTTP.result.desiredNumberOfStakePools == 500)
    #expect(stakePoolsPerformancesHTTP.result.stakePoolPledgeInfluence.value == "3/10")
    #expect(stakePoolsPerformancesHTTP.result.stakePools.count == 3)
    
    #expect(stakePoolsPerformancesWS.result.desiredNumberOfStakePools == 500)
    #expect(stakePoolsPerformancesWS.result.stakePoolPledgeInfluence.value == "3/10")
    #expect(stakePoolsPerformancesWS.result.stakePools.count == 3)
}
