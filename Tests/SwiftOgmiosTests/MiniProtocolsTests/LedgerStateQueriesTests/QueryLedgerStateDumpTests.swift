import Testing
import Foundation
@testable import SwiftOgmios

@Test func testQueryLedgerStateDump() async throws {
    let httpClient = try await OgmiosClient(httpOnly: true) // Use `httpOnly: true` for HTTP
    let wsClient = try await OgmiosClient(httpOnly: false) // Use `httpOnly: false` for WebSocket
    
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
    
    let dumpHTTP = try await httpClient.ledgerStateQuery.dump.execute(
        id: .number(httpClient.getNextRequestId()),
        params: .init(to: tempFileHTTP.path)
    )
    let dumpWS = try await wsClient.ledgerStateQuery.dump.execute(
        id: .number(httpClient.getNextRequestId()),
        params: .init(to: tempFileWS.path)
    )
    
    let httpSize = try FileManager.default.attributesOfItem(atPath: tempFileHTTP.path)[.size] as? NSNumber
    let wsSize = try FileManager.default.attributesOfItem(atPath: tempFileWS.path)[.size] as? NSNumber
    
    print("Constitution (HTTP): \(dumpHTTP)")
    print("Constitution (WS): \(dumpWS)")
    
    #expect((httpSize?.intValue ?? 0) > 0, "HTTP dump file is empty")
    #expect((wsSize?.intValue ?? 0) > 0, "WS dump file is empty")
}


