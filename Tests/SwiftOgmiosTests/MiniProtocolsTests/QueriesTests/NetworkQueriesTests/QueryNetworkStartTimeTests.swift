import Testing
import Foundation
@testable import SwiftOgmios

@Test func testQueryNetworkStartTime() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let startTimeHTTP = try await httpClient
        .networkQuery
        .startTime
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let startTimeWS = try await wsClient
        .networkQuery
        .startTime
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    let formatter = ISO8601DateFormatter()
    let expectedDate = formatter.date(from: "2022-10-25T00:00:00Z")!
    
    #expect(startTimeHTTP.result.value == expectedDate)
    #expect(startTimeWS.result.value == expectedDate)
}
