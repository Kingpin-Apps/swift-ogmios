import Testing
@testable import SwiftOgmios

@Test func testFindIntersection() async throws {
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
    
    let findIntersectionHTTP = try await httpClient
        .chainSync
        .findIntersection
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(points: [.origin(.origin)])
        )
    let findIntersectionWS = try await wsClient
        .chainSync
        .findIntersection
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(points: [.origin(.origin)])
        )
    
    if case let .point(point) = findIntersectionHTTP.result.intersection {
        #expect(point.slot == 18446744073709552000)
    } else {
        Issue.record("Expected point case")
        return
    }
    
    if case let .point(point) = findIntersectionWS.result.intersection {
        #expect(point.slot == 18446744073709552000)
    } else {
        Issue.record("Expected transactionId case")
        return
    }
    
    if case let .tip(tip) = findIntersectionHTTP.result.tip {
        #expect(tip.slot == 18446744073709552000)
    } else {
        Issue.record("Expected point case")
        return
    }
    
    if case let .tip(tip) = findIntersectionWS.result.tip {
        #expect(tip.slot == 18446744073709552000)
    } else {
        Issue.record("Expected transactionId case")
        return
    }
}

@Test func testIntersectionNotFoundErrorDecoding() async throws {
    let jsonString = """
        {
            "jsonrpc": "2.0",
            "method": "findIntersection",
            "error": {
                "code": 1000,
                "message": "No intersection found with the requested points.",
                "data": {
                    "tip": { 
                        "slot": 18446744073709552000, 
                        "id": "c248757d390181c517a5beadc9c3fe64bf821d3e889a963fc717003ec248757d",
                        "height": 18446744073709552000 
                    }
                }
            },
            "id": "test-id"
        }
        """
    
    let data = jsonString.data(using: .utf8)!
    let result = try FindIntersectionError<IntersectionNotFound>.fromJSONData(data)
    
    #expect(result.error.code == 1000)
    #expect(result.error.message == "No intersection found with the requested points.")
}
