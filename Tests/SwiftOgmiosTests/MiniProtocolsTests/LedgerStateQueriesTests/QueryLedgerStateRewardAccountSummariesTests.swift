import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateRewardAccountSummaries() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let rewardAccountSummariesHTTP = try await httpClient
        .ledgerStateQuery
        .rewardAccountSummaries
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(
                keys: [
                    .base16(
                        EncodingBase16(
                            "1b515807ebb8a99331ddeb20395267e83f29b80716ada5ea37c0a062"
                        )
                    )
                ]
            )
        )
    let rewardAccountSummariesWS = try await wsClient
        .ledgerStateQuery
        .rewardAccountSummaries
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(
                keys: [
                    .base16(
                        EncodingBase16(
                            "1b515807ebb8a99331ddeb20395267e83f29b80716ada5ea37c0a062"
                        )
                    )
                ]
            )
        )
    
    #expect(rewardAccountSummariesHTTP.result.count == 1)
    #expect(rewardAccountSummariesWS.result.count == 1)
}
