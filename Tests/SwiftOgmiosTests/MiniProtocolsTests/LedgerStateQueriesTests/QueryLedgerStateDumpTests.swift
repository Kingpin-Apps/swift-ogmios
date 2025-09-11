import Testing
import Foundation
@testable import SwiftOgmios

@Test func testQueryLedgerStateDump() async throws {
    let mockHTTPConnection = MockHTTPConnection()
    let mockWebSocketConnection = MockWebSocketConnection()
    
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: mockHTTPConnection
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: mockWebSocketConnection
    )
    
    let tempFileHTTP = FileManager
        .default
        .temporaryDirectory
        .appendingPathComponent(
            UUID().uuidString
        )
    let tempFileWS = FileManager
        .default
        .temporaryDirectory
        .appendingPathComponent(
            UUID().uuidString
        )
    
    defer {
        try? FileManager.default.removeItem(at: tempFileHTTP)
        try? FileManager.default.removeItem(at: tempFileWS)
    }
    
    _ = try await httpClient.ledgerStateQuery.dump.execute(
        id: JSONRPCId.generateNextNanoId(),
        params: .init(to: tempFileHTTP.path)
    )
    _ = try await wsClient.ledgerStateQuery.dump.execute(
        id: JSONRPCId.generateNextNanoId(),
        params: .init(to: tempFileWS.path)
    )
    
    let httpSize = try FileManager.default.attributesOfItem(atPath: tempFileHTTP.path)[.size] as? NSNumber
    let wsSize = try FileManager.default.attributesOfItem(atPath: tempFileWS.path)[.size] as? NSNumber
    
    #expect((httpSize?.intValue ?? 0) > 0, "HTTP dump file is empty")
    #expect((wsSize?.intValue ?? 0) > 0, "WS dump file is empty")
}


