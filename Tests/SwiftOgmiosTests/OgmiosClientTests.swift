import Foundation
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

/// An `HTTPConnectable` that records the `/health` URLs it was asked for, so a test can tell
/// the difference between "the injected connection served this" and "a real HTTP call did".
public final class RecordingHTTPConnection: HTTPConnectable, @unchecked Sendable {
    private let lock = NSLock()
    private var _requestedURLs: [URL] = []
    private let inner = MockHTTPConnection()

    public var requestedURLs: [URL] {
        lock.withLock { _requestedURLs }
    }

    public func sendRequest(json: String) async throws -> Data {
        try await inner.sendRequest(json: json)
    }

    public func get(url: URL) async throws -> Data {
        lock.withLock { _requestedURLs.append(url) }
        return try await inner.get(url: url)
    }
}

@Test func testGetServerHealthReusesTheClientsConnection() async throws {
    // No `httpConnection:` argument on the `getServerHealth()` calls below: the client has to
    // fall back to the connection it was built with. Before this was fixed it built a fresh
    // `HTTPConnection` instead and issued a real request to the configured host, which made
    // "mocked" callers quietly depend on whatever was listening on that port.
    let connection = RecordingHTTPConnection()
    let httpClient = try await OgmiosClient(httpOnly: true, httpConnection: connection)

    let health = try await httpClient.getServerHealth()

    #expect(health.currentEpoch == 1052)
    #expect(health.slotInEpoch == 15755)
    #expect(connection.requestedURLs.count == 1)
    #expect(connection.requestedURLs.first?.path == "/health")
}

@Test func testGetServerHealthOverWebSocketTransportStillWorks() async throws {
    // A WebSocket client has no HTTP connection of its own, so the throwaway-connection
    // fallback has to stay in place for it. An explicitly supplied connection still wins.
    let connection = RecordingHTTPConnection()
    let wsClient = try await OgmiosClient(httpOnly: false)

    let health = try await wsClient.getServerHealth(httpConnection: connection)

    #expect(health.connectionStatus == "connected")
    #expect(connection.requestedURLs.first?.scheme == "http")
    #expect(connection.requestedURLs.first?.path == "/health")
}
