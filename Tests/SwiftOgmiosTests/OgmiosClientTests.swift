import Testing
@testable import SwiftOgmios

@Test func testOgmiosClient() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
    let healthHTTP = try await httpClient.getServerHealth()
    let healthWS = try await wsClient.getServerHealth()
    
    print("Health (HTTP): \(healthHTTP)")
    print("Health (WS): \(healthWS)")
}
