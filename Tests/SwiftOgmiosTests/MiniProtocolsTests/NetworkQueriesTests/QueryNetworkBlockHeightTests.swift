import Testing
@testable import SwiftOgmios

@Test func testQueryNetworkBlockHeight() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let blockHeightHTTP = try await httpClient
        .networkQuery
        .blockHeight
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let blockHeightWS = try await wsClient
        .networkQuery
        .blockHeight
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    guard case let .blockHeight(blockHTTP) = blockHeightHTTP.result else {
        Issue.record("Expected ledger tip to be of type .point")
        return
    }
    guard case let .blockHeight(blockWS) = blockHeightWS.result else {
        Issue.record("Expected ledger tip to be of type .point")
        return
    }
    
    #expect(blockHTTP == 3605225)
    #expect(blockWS == 3605225)
}
