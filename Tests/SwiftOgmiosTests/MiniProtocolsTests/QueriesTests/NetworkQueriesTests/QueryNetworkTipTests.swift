import Testing
@testable import SwiftOgmios

@Test func testQueryNetworkTip() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let tipHTTP = try await httpClient
        .networkQuery
        .tip
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let tipWS = try await wsClient
        .networkQuery
        .tip
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    guard case let .point(pointHTTP) = tipHTTP.result else {
        Issue.record("Expected network tip to be of type .point")
        return
    }
    guard case let .point(pointWS) = tipWS.result else {
        Issue.record("Expected network tip to be of type .point")
        return
    }
    
    #expect(pointHTTP.slot == 91219322)
    #expect(pointWS.slot == 91219322)
    #expect(pointHTTP.id() == "6bf2e5f0d268bd08ec19e4f3d0aa522416b6ca775c22b4ea0a9818e41d249f27")
    #expect(pointWS.id() == "6bf2e5f0d268bd08ec19e4f3d0aa522416b6ca775c22b4ea0a9818e41d249f27")
}
