import Testing
@testable import SwiftOgmios

@Test func testNextBlock() async throws {
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
    
    let nextBlockHTTP = try await httpClient
        .chainSync
        .nextBlock
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    let nextBlockWS = try await wsClient
        .chainSync
        .nextBlock
        .execute(
            id: JSONRPCId.generateNextNanoId()
        )
    
    if case let .rollforward(rollforward) = nextBlockHTTP.result {
        if case let .ebb(block) = rollforward.block {
            #expect(block.type == "ebb")
        } else {
            Issue.record("Expected ebb case")
            return
        }
    } else {
        Issue.record("Expected rollforward case")
        return
    }
    
    if case let .rollforward(rollforward) = nextBlockWS.result {
        if case let .ebb(block) = rollforward.block {
            #expect(block.type == "ebb")
        } else {
            Issue.record("Expected ebb case")
            return
        }
    } else {
        Issue.record("Expected rollforward case")
        return
    }
}
