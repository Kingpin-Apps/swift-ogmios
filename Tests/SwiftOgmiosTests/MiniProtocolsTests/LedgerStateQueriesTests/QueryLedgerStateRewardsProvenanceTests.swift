import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateRewardsProvenance() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let rewardsProvenanceHTTP = try await httpClient
        .ledgerStateQuery
        .rewardsProvenance
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let rewardsProvenanceWS = try await wsClient
        .ledgerStateQuery
        .rewardsProvenance
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    #expect(rewardsProvenanceHTTP.result.desiredNumberOfStakePools == 500)
    #expect(rewardsProvenanceHTTP.result.stakePoolPledgeInfluence.value == "3/10")
    #expect(rewardsProvenanceHTTP.result.stakePools.count == 3)
    
    #expect(rewardsProvenanceWS.result.desiredNumberOfStakePools == 500)
    #expect(rewardsProvenanceWS.result.stakePoolPledgeInfluence.value == "3/10")
    #expect(rewardsProvenanceWS.result.stakePools.count == 3)
}


