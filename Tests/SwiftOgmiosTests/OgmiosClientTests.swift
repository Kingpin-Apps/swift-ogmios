import Testing
@testable import SwiftOgmios

@Test func testOgmiosClient() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let mockHTTPConnection = MockHTTPConnection()
    
    let healthHTTP = try await httpClient.getServerHealth(httpConnection: mockHTTPConnection)
    let healthWS = try await wsClient.getServerHealth(httpConnection: mockHTTPConnection)
    
    #expect(healthHTTP.connectionStatus == "connected")
    #expect(healthWS.connectionStatus == "connected")
}
