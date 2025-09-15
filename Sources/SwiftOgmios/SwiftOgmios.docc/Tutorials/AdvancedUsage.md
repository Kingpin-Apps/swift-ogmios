# Advanced Usage

Master advanced SwiftOgmios patterns including testing strategies, concurrency patterns, performance optimization, and production deployment considerations.

## Overview

This tutorial covers advanced SwiftOgmios usage patterns for production applications. You'll learn about testing strategies, concurrency best practices, performance optimization techniques, monitoring and observability, and deployment patterns.

These advanced patterns help you build robust, scalable, and maintainable Cardano applications using SwiftOgmios.

## Testing Strategies

### Unit Testing with Mock Clients

```swift path=null start=null
import XCTest
@testable import SwiftOgmios

// Protocol for testable Ogmios client
protocol OgmiosClientProtocol {
    func ledgerStateQuery() -> LedgerStateQueryProtocol
    func transactionSubmission() -> TransactionSubmissionProtocol
    func chainSync() -> ChainSyncProtocol
    func mempoolMonitor() -> MempoolMonitorProtocol
}

// Mock implementation for testing
class MockOgmiosClient: OgmiosClientProtocol {
    var mockResponses: [String: Any] = [:]
    var networkDelay: TimeInterval = 0
    var shouldFailNextRequest = false
    var callCount: [String: Int] = [:]
    
    func ledgerStateQuery() -> LedgerStateQueryProtocol {
        return MockLedgerStateQuery(client: self)
    }
    
    func transactionSubmission() -> TransactionSubmissionProtocol {
        return MockTransactionSubmission(client: self)
    }
    
    func chainSync() -> ChainSyncProtocol {
        return MockChainSync(client: self)
    }
    
    func mempoolMonitor() -> MempoolMonitorProtocol {
        return MockMempoolMonitor(client: self)
    }
    
    func simulateNetworkDelay() async {
        if networkDelay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(networkDelay * 1_000_000_000))
        }
    }
    
    func recordCall(_ methodName: String) {
        callCount[methodName, default: 0] += 1
    }
}

class MockLedgerStateQuery: LedgerStateQueryProtocol {
    private let client: MockOgmiosClient
    
    init(client: MockOgmiosClient) {
        self.client = client
    }
    
    func tip() async throws -> JSONRPCResponse<TipResult> {
        await client.simulateNetworkDelay()
        client.recordCall("tip")
        
        if client.shouldFailNextRequest {
            client.shouldFailNextRequest = false
            throw OgmiosError.networkError("Simulated network error")
        }
        
        if let mockTip = client.mockResponses["tip"] as? TipResult {
            return JSONRPCResponse<TipResult>(
                id: .string("test"),
                result: mockTip
            )
        }
        
        // Default mock response
        return JSONRPCResponse<TipResult>(
            id: .string("test"),
            result: TipResult(
                slot: 12345,
                hash: "abc123",
                height: 1000
            )
        )
    }
    
    func protocolParameters() async throws -> JSONRPCResponse<ProtocolParameters> {
        await client.simulateNetworkDelay()
        client.recordCall("protocolParameters")
        
        if client.shouldFailNextRequest {
            client.shouldFailNextRequest = false
            throw OgmiosError.networkError("Simulated network error")
        }
        
        if let mockParams = client.mockResponses["protocolParameters"] as? ProtocolParameters {
            return JSONRPCResponse<ProtocolParameters>(
                id: .string("test"),
                result: mockParams
            )
        }
        
        // Default mock response
        return JSONRPCResponse<ProtocolParameters>(
            id: .string("test"),
            result: ProtocolParameters(
                minFeeConstant: 155381,
                minFeeCoefficient: 44,
                maxTxSize: 16384,
                maxBlockHeaderSize: 1100,
                keyDeposit: 2000000,
                poolDeposit: 500000000
            )
        )
    }
}

// Example test cases
class OgmiosClientTests: XCTestCase {
    var mockClient: MockOgmiosClient!
    var service: CardanoService!
    
    override func setUp() {
        super.setUp()
        mockClient = MockOgmiosClient()
        service = CardanoService(client: mockClient)
    }
    
    func testGetCurrentTip_Success() async throws {
        // Given
        let expectedTip = TipResult(
            slot: 54321,
            hash: "def456",
            height: 2000
        )
        mockClient.mockResponses["tip"] = expectedTip
        
        // When
        let result = try await service.getCurrentTip()
        
        // Then
        XCTAssertEqual(result.slot, expectedTip.slot)
        XCTAssertEqual(result.hash, expectedTip.hash)
        XCTAssertEqual(result.height, expectedTip.height)
        XCTAssertEqual(mockClient.callCount["tip"], 1)
    }
    
    func testGetCurrentTip_NetworkError() async {
        // Given
        mockClient.shouldFailNextRequest = true
        
        // When/Then
        do {
            _ = try await service.getCurrentTip()
            XCTFail("Expected network error")
        } catch OgmiosError.networkError(let message) {
            XCTAssertEqual(message, "Simulated network error")
        } catch {
            XCTFail("Expected OgmiosError.networkError, got \(error)")
        }
    }
    
    func testGetCurrentTip_WithDelay() async throws {
        // Given
        mockClient.networkDelay = 0.1 // 100ms delay
        let startTime = Date()
        
        // When
        _ = try await service.getCurrentTip()
        
        // Then
        let elapsedTime = Date().timeIntervalSince(startTime)
        XCTAssertGreaterThan(elapsedTime, 0.09) // Should be at least 90ms
    }
}

// Service class using protocol for testability
class CardanoService {
    private let client: OgmiosClientProtocol
    
    init(client: OgmiosClientProtocol) {
        self.client = client
    }
    
    func getCurrentTip() async throws -> TipResult {
        let response = try await client.ledgerStateQuery().tip()
        return response.result
    }
    
    func getProtocolParameters() async throws -> ProtocolParameters {
        let response = try await client.ledgerStateQuery().protocolParameters()
        return response.result
    }
}
```

### Integration Testing

```swift path=null start=null
class OgmiosIntegrationTests: XCTestCase {
    var client: OgmiosClient!
    var testConfiguration: TestConfiguration!
    
    struct TestConfiguration {
        let host: String
        let port: Int
        let secure: Bool
        let timeout: TimeInterval
        
        static var `default`: TestConfiguration {
            return TestConfiguration(
                host: ProcessInfo.processInfo.environment["OGMIOS_HOST"] ?? "localhost",
                port: Int(ProcessInfo.processInfo.environment["OGMIOS_PORT"] ?? "1337") ?? 1337,
                secure: ProcessInfo.processInfo.environment["OGMIOS_SECURE"] == "true",
                timeout: 30.0
            )
        }
    }
    
    override func setUpWithError() throws {
        super.setUp()
        testConfiguration = TestConfiguration.default
        
        // Skip integration tests if no Ogmios server is available
        guard isOgmiosServerAvailable() else {
            throw XCTSkip("Ogmios server not available at \(testConfiguration.host):\(testConfiguration.port)")
        }
    }
    
    override func tearDown() {
        client = nil
        super.tearDown()
    }
    
    func testHTTPConnection() async throws {
        // Given
        client = try await OgmiosClient(
            host: testConfiguration.host,
            port: testConfiguration.port,
            secure: testConfiguration.secure,
            httpOnly: true
        )
        
        // When
        let response = try await client.ledgerStateQuery.tip.execute()
        
        // Then
        XCTAssertNotNil(response.result)
        XCTAssertGreaterThan(response.result.slot, 0)
        XCTAssertFalse(response.result.hash.isEmpty)
    }
    
    func testWebSocketConnection() async throws {
        // Given
        client = try await OgmiosClient(
            host: testConfiguration.host,
            port: testConfiguration.port,
            secure: testConfiguration.secure,
            httpOnly: false
        )
        
        // When
        let response = try await client.ledgerStateQuery.tip.execute()
        
        // Then
        XCTAssertNotNil(response.result)
        XCTAssertGreaterThan(response.result.slot, 0)
        XCTAssertFalse(response.result.hash.isEmpty)
    }
    
    func testConcurrentRequests() async throws {
        // Given
        client = try await OgmiosClient(
            host: testConfiguration.host,
            port: testConfiguration.port,
            secure: testConfiguration.secure,
            httpOnly: false
        )
        
        // When - Execute multiple concurrent requests
        let tasks = (0..<10).map { _ in
            Task {
                try await client.ledgerStateQuery.tip.execute()
            }
        }
        
        let responses = try await withThrowingTaskGroup(of: JSONRPCResponse<TipResult>.self) { group in
            for task in tasks {
                group.addTask {
                    try await task.value
                }
            }
            
            var results: [JSONRPCResponse<TipResult>] = []
            for try await response in group {
                results.append(response)
            }
            return results
        }
        
        // Then
        XCTAssertEqual(responses.count, 10)
        for response in responses {
            XCTAssertGreaterThan(response.result.slot, 0)
        }
    }
    
    func testConnectionResilience() async throws {
        // Given
        client = try await OgmiosClient(
            host: testConfiguration.host,
            port: testConfiguration.port,
            secure: testConfiguration.secure,
            httpOnly: false
        )
        
        // When - Make requests with simulated network issues
        var successCount = 0
        var errorCount = 0
        
        for i in 0..<20 {
            do {
                _ = try await client.ledgerStateQuery.tip.execute()
                successCount += 1
                
                // Add small delay between requests
                try await Task.sleep(nanoseconds: 100_000_000) // 100ms
                
            } catch {
                errorCount += 1
                print("Request \(i) failed: \(error)")
            }
        }
        
        // Then - Expect high success rate
        let successRate = Double(successCount) / 20.0
        XCTAssertGreaterThan(successRate, 0.9, "Expected > 90% success rate, got \(successRate)")
    }
    
    private func isOgmiosServerAvailable() -> Bool {
        // Simple TCP connection test
        let semaphore = DispatchSemaphore(value: 0)
        var isAvailable = false
        
        let task = URLSession.shared.dataTask(with: URL(string: "http://\(testConfiguration.host):\(testConfiguration.port)")!) { _, _, error in
            isAvailable = (error == nil)
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: .now() + 5.0) // 5 second timeout
        
        return isAvailable
    }
}
```

### Performance Testing

```swift path=null start=null
class OgmiosPerformanceTests: XCTestCase {
    var client: OgmiosClient!
    
    override func setUpWithError() throws {
        super.setUp()
        client = try await OgmiosClient(
            host: "localhost",
            port: 1337,
            secure: false,
            httpOnly: false
        )
    }
    
    func testLedgerQueryPerformance() {
        measure {
            let expectation = XCTestExpectation(description: "Ledger query performance")
            
            Task {
                do {
                    _ = try await client.ledgerStateQuery.tip.execute()
                    expectation.fulfill()
                } catch {
                    XCTFail("Performance test failed: \(error)")
                }
            }
            
            wait(for: [expectation], timeout: 10.0)
        }
    }
    
    func testConcurrentRequestPerformance() {
        measure {
            let expectation = XCTestExpectation(description: "Concurrent request performance")
            expectation.expectedFulfillmentCount = 50
            
            for _ in 0..<50 {
                Task {
                    do {
                        _ = try await client.ledgerStateQuery.tip.execute()
                        expectation.fulfill()
                    } catch {
                        XCTFail("Concurrent request failed: \(error)")
                    }
                }
            }
            
            wait(for: [expectation], timeout: 30.0)
        }
    }
    
    func testMemoryUsageDuringLongRunningOperations() {
        let initialMemory = getCurrentMemoryUsage()
        
        measure {
            let expectation = XCTestExpectation(description: "Memory usage test")
            
            Task {
                for _ in 0..<1000 {
                    do {
                        _ = try await client.ledgerStateQuery.tip.execute()
                    } catch {
                        // Log but don't fail on individual errors
                        print("Request failed: \(error)")
                    }
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 60.0)
        }
        
        let finalMemory = getCurrentMemoryUsage()
        let memoryIncrease = finalMemory - initialMemory
        
        // Assert memory usage didn't increase by more than 50MB
        XCTAssertLessThan(memoryIncrease, 50 * 1024 * 1024, "Memory usage increased by \(memoryIncrease) bytes")
    }
    
    private func getCurrentMemoryUsage() -> Int64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Int64(info.resident_size)
        } else {
            return 0
        }
    }
}
```

## Advanced Concurrency Patterns

### Actor-Based Connection Management

```swift path=null start=null
actor ConnectionManager {
    private var connections: [String: OgmiosClient] = [:]
    private let maxConnections: Int
    private let configuration: ConnectionConfiguration
    
    struct ConnectionConfiguration {
        let maxConnectionsPerHost: Int
        let connectionTimeout: TimeInterval
        let keepAliveInterval: TimeInterval
        let maxRetries: Int
        
        static let `default` = ConnectionConfiguration(
            maxConnectionsPerHost: 5,
            connectionTimeout: 30.0,
            keepAliveInterval: 60.0,
            maxRetries: 3
        )
    }
    
    init(maxConnections: Int = 10, configuration: ConnectionConfiguration = .default) {
        self.maxConnections = maxConnections
        self.configuration = configuration
    }
    
    func getConnection(for endpoint: Endpoint) async throws -> OgmiosClient {
        let key = endpoint.key
        
        if let existingConnection = connections[key] {
            // Test connection health
            if await isConnectionHealthy(existingConnection) {
                return existingConnection
            } else {
                // Remove stale connection
                connections.removeValue(forKey: key)
            }
        }
        
        // Create new connection if under limit
        guard connections.count < maxConnections else {
            throw ConnectionError.maxConnectionsExceeded
        }
        
        let client = try await createConnection(for: endpoint)
        connections[key] = client
        
        return client
    }
    
    func closeConnection(for endpoint: Endpoint) {
        let key = endpoint.key
        connections.removeValue(forKey: key)
    }
    
    func closeAllConnections() {
        connections.removeAll()
    }
    
    private func createConnection(for endpoint: Endpoint) async throws -> OgmiosClient {
        return try await OgmiosClient(\n            host: endpoint.host,\n            port: endpoint.port,\n            secure: endpoint.secure,\n            httpOnly: endpoint.httpOnly\n        )\n    }\n    \n    private func isConnectionHealthy(_ client: OgmiosClient) async -> Bool {\n        do {\n            _ = try await client.ledgerStateQuery.tip.execute()\n            return true\n        } catch {\n            return false\n        }\n    }\n}\n\nstruct Endpoint {\n    let host: String\n    let port: Int\n    let secure: Bool\n    let httpOnly: Bool\n    \n    var key: String {\n        return \"\\(secure ? \"https\" : \"http\")://\\(host):\\(port)/\\(httpOnly ? \"http\" : \"ws\")\"\n    }\n}\n\nenum ConnectionError: Error {\n    case maxConnectionsExceeded\n    case connectionFailed(String)\n    case healthCheckFailed\n}\n```\n\n### Request Queue and Rate Limiting\n\n```swift path=null start=null\nactor RequestQueue {\n    private var pendingRequests: [(Request, CheckedContinuation<Any, Error>)] = []\n    private var activeRequests: Set<UUID> = []\n    private let maxConcurrentRequests: Int\n    private let rateLimitInterval: TimeInterval\n    private var lastRequestTime: Date = .distantPast\n    private let requestSemaphore: AsyncSemaphore\n    \n    struct Request {\n        let id: UUID\n        let priority: Priority\n        let operation: () async throws -> Any\n        \n        enum Priority: Int, Comparable {\n            case low = 0\n            case normal = 1\n            case high = 2\n            case critical = 3\n            \n            static func < (lhs: Priority, rhs: Priority) -> Bool {\n                return lhs.rawValue < rhs.rawValue\n            }\n        }\n    }\n    \n    init(maxConcurrentRequests: Int = 10, rateLimitInterval: TimeInterval = 0.1) {\n        self.maxConcurrentRequests = maxConcurrentRequests\n        self.rateLimitInterval = rateLimitInterval\n        self.requestSemaphore = AsyncSemaphore(value: maxConcurrentRequests)\n    }\n    \n    func enqueue<T>(\n        priority: Request.Priority = .normal,\n        operation: @escaping () async throws -> T\n    ) async throws -> T {\n        return try await withCheckedThrowingContinuation { continuation in\n            let request = Request(\n                id: UUID(),\n                priority: priority\n            ) {\n                try await operation()\n            }\n            \n            pendingRequests.append((request, continuation))\n            pendingRequests.sort { $0.0.priority > $1.0.priority }\n            \n            Task {\n                await processNextRequest()\n            }\n        }\n    }\n    \n    private func processNextRequest() async {\n        guard !pendingRequests.isEmpty else { return }\n        \n        // Rate limiting\n        let timeSinceLastRequest = Date().timeIntervalSince(lastRequestTime)\n        if timeSinceLastRequest < rateLimitInterval {\n            let delay = rateLimitInterval - timeSinceLastRequest\n            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))\n        }\n        \n        await requestSemaphore.wait()\n        \n        guard let (request, continuation) = pendingRequests.first else {\n            requestSemaphore.signal()\n            return\n        }\n        \n        pendingRequests.removeFirst()\n        activeRequests.insert(request.id)\n        lastRequestTime = Date()\n        \n        Task {\n            defer {\n                Task {\n                    await self.requestComplete(request.id)\n                }\n            }\n            \n            do {\n                let result = try await request.operation()\n                continuation.resume(returning: result)\n            } catch {\n                continuation.resume(throwing: error)\n            }\n        }\n    }\n    \n    private func requestComplete(_ requestId: UUID) {\n        activeRequests.remove(requestId)\n        requestSemaphore.signal()\n        \n        // Process next request if any are pending\n        if !pendingRequests.isEmpty {\n            Task {\n                await processNextRequest()\n            }\n        }\n    }\n    \n    var queueStatus: QueueStatus {\n        return QueueStatus(\n            pendingCount: pendingRequests.count,\n            activeCount: activeRequests.count,\n            maxConcurrent: maxConcurrentRequests\n        )\n    }\n}\n\nstruct QueueStatus {\n    let pendingCount: Int\n    let activeCount: Int\n    let maxConcurrent: Int\n    \n    var utilizationPercentage: Double {\n        return Double(activeCount) / Double(maxConcurrent) * 100.0\n    }\n}\n\nactor AsyncSemaphore {\n    private var value: Int\n    private var waiters: [CheckedContinuation<Void, Never>] = []\n    \n    init(value: Int) {\n        self.value = value\n    }\n    \n    func wait() async {\n        if value > 0 {\n            value -= 1\n        } else {\n            await withCheckedContinuation { continuation in\n                waiters.append(continuation)\n            }\n        }\n    }\n    \n    func signal() {\n        if waiters.isEmpty {\n            value += 1\n        } else {\n            let waiter = waiters.removeFirst()\n            waiter.resume()\n        }\n    }\n}\n```\n\n### Batch Processing with Concurrency Control\n\n```swift path=null start=null\nclass BatchProcessor<Input, Output> {\n    private let processItem: (Input) async throws -> Output\n    private let batchSize: Int\n    private let maxConcurrency: Int\n    private let retryAttempts: Int\n    \n    init(\n        batchSize: Int = 10,\n        maxConcurrency: Int = 5,\n        retryAttempts: Int = 3,\n        processItem: @escaping (Input) async throws -> Output\n    ) {\n        self.batchSize = batchSize\n        self.maxConcurrency = maxConcurrency\n        self.retryAttempts = retryAttempts\n        self.processItem = processItem\n    }\n    \n    func process(\n        _ items: [Input],\n        onProgress: ((BatchProgress<Output>) -> Void)? = nil\n    ) async -> BatchResult<Input, Output> {\n        let totalItems = items.count\n        var processedCount = 0\n        var results: [Result<Output, Error>] = []\n        var failedItems: [(Input, Error)] = []\n        \n        onProgress?(.started(total: totalItems))\n        \n        // Process items in batches\n        let batches = items.chunked(into: batchSize)\n        \n        for batch in batches {\n            let batchResults = await processBatch(batch)\n            \n            for (index, result) in batchResults.enumerated() {\n                let originalIndex = processedCount + index\n                let item = batch[index]\n                \n                switch result {\n                case .success(let output):\n                    results.append(.success(output))\n                case .failure(let error):\n                    results.append(.failure(error))\n                    failedItems.append((item, error))\n                }\n            }\n            \n            processedCount += batch.count\n            onProgress?(.progress(completed: processedCount, total: totalItems))\n        }\n        \n        onProgress?(.completed(successful: results.compactMap { try? $0.get() }.count, failed: failedItems.count))\n        \n        return BatchResult(\n            totalItems: totalItems,\n            results: results,\n            failedItems: failedItems\n        )\n    }\n    \n    private func processBatch(_ batch: [Input]) async -> [Result<Output, Error>] {\n        return await withTaskGroup(of: (Int, Result<Output, Error>).self) { group in\n            // Add tasks with concurrency control\n            let semaphore = AsyncSemaphore(value: maxConcurrency)\n            \n            for (index, item) in batch.enumerated() {\n                group.addTask {\n                    await semaphore.wait()\n                    defer { Task { await semaphore.signal() } }\n                    \n                    let result = await self.processItemWithRetry(item)\n                    return (index, result)\n                }\n            }\n            \n            // Collect results in order\n            var results: [Result<Output, Error>] = Array(repeating: .failure(ProcessingError.notProcessed), count: batch.count)\n            \n            for await (index, result) in group {\n                results[index] = result\n            }\n            \n            return results\n        }\n    }\n    \n    private func processItemWithRetry(_ item: Input) async -> Result<Output, Error> {\n        var lastError: Error?\n        \n        for attempt in 1...retryAttempts {\n            do {\n                let output = try await processItem(item)\n                return .success(output)\n            } catch {\n                lastError = error\n                \n                // Exponential backoff for retries\n                if attempt < retryAttempts {\n                    let delay = TimeInterval(pow(2.0, Double(attempt - 1)))\n                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))\n                }\n            }\n        }\n        \n        return .failure(lastError ?? ProcessingError.unknownError)\n    }\n}\n\nenum ProcessingError: Error {\n    case notProcessed\n    case unknownError\n}\n\nenum BatchProgress<Output> {\n    case started(total: Int)\n    case progress(completed: Int, total: Int)\n    case completed(successful: Int, failed: Int)\n}\n\nstruct BatchResult<Input, Output> {\n    let totalItems: Int\n    let results: [Result<Output, Error>]\n    let failedItems: [(Input, Error)]\n    \n    var successfulCount: Int {\n        return results.compactMap { try? $0.get() }.count\n    }\n    \n    var failedCount: Int {\n        return failedItems.count\n    }\n    \n    var successRate: Double {\n        return Double(successfulCount) / Double(totalItems)\n    }\n}\n\nextension Array {\n    func chunked(into size: Int) -> [[Element]] {\n        return stride(from: 0, to: count, by: size).map {\n            Array(self[$0..<Swift.min($0 + size, count)])\n        }\n    }\n}\n```\n\n## Performance Optimization\n\n### Connection Pooling and Reuse\n\n```swift path=null start=null\nactor ConnectionPool {\n    private var availableConnections: [ConnectionPoolItem] = []\n    private var activeConnections: Set<UUID> = []\n    private let maxPoolSize: Int\n    private let maxIdleTime: TimeInterval\n    private let cleanupInterval: TimeInterval\n    private var cleanupTask: Task<Void, Never>?\n    \n    struct ConnectionPoolItem {\n        let id: UUID\n        let client: OgmiosClient\n        let endpoint: Endpoint\n        let createdAt: Date\n        var lastUsed: Date\n        var useCount: Int\n        \n        var isStale: Bool {\n            return Date().timeIntervalSince(lastUsed) > 300 // 5 minutes\n        }\n    }\n    \n    init(\n        maxPoolSize: Int = 20,\n        maxIdleTime: TimeInterval = 600, // 10 minutes\n        cleanupInterval: TimeInterval = 60 // 1 minute\n    ) {\n        self.maxPoolSize = maxPoolSize\n        self.maxIdleTime = maxIdleTime\n        self.cleanupInterval = cleanupInterval\n        \n        startCleanupTask()\n    }\n    \n    func borrowConnection(for endpoint: Endpoint) async throws -> (UUID, OgmiosClient) {\n        // Try to find available connection for this endpoint\n        if let index = availableConnections.firstIndex(where: { \n            $0.endpoint.key == endpoint.key && !$0.isStale \n        }) {\n            var item = availableConnections.remove(at: index)\n            item.lastUsed = Date()\n            item.useCount += 1\n            \n            activeConnections.insert(item.id)\n            return (item.id, item.client)\n        }\n        \n        // Create new connection if pool isn't full\n        guard totalConnections < maxPoolSize else {\n            throw ConnectionPoolError.poolExhausted\n        }\n        \n        let client = try await OgmiosClient(\n            host: endpoint.host,\n            port: endpoint.port,\n            secure: endpoint.secure,\n            httpOnly: endpoint.httpOnly\n        )\n        \n        let id = UUID()\n        activeConnections.insert(id)\n        \n        return (id, client)\n    }\n    \n    func returnConnection(_ id: UUID, client: OgmiosClient, endpoint: Endpoint) {\n        guard activeConnections.contains(id) else { return }\n        \n        activeConnections.remove(id)\n        \n        // Add back to available pool if healthy and under limit\n        if availableConnections.count < maxPoolSize {\n            let item = ConnectionPoolItem(\n                id: id,\n                client: client,\n                endpoint: endpoint,\n                createdAt: Date(),\n                lastUsed: Date(),\n                useCount: 1\n            )\n            availableConnections.append(item)\n        }\n    }\n    \n    private var totalConnections: Int {\n        return availableConnections.count + activeConnections.count\n    }\n    \n    private func startCleanupTask() {\n        cleanupTask = Task {\n            while !Task.isCancelled {\n                try? await Task.sleep(nanoseconds: UInt64(cleanupInterval * 1_000_000_000))\n                await cleanup()\n            }\n        }\n    }\n    \n    private func cleanup() {\n        let now = Date()\n        availableConnections.removeAll { item in\n            now.timeIntervalSince(item.lastUsed) > maxIdleTime || item.isStale\n        }\n    }\n    \n    var poolStatistics: PoolStatistics {\n        return PoolStatistics(\n            totalConnections: totalConnections,\n            availableConnections: availableConnections.count,\n            activeConnections: activeConnections.count,\n            maxPoolSize: maxPoolSize\n        )\n    }\n    \n    deinit {\n        cleanupTask?.cancel()\n    }\n}\n\nstruct PoolStatistics {\n    let totalConnections: Int\n    let availableConnections: Int\n    let activeConnections: Int\n    let maxPoolSize: Int\n    \n    var utilizationPercentage: Double {\n        return Double(totalConnections) / Double(maxPoolSize) * 100.0\n    }\n}\n\nenum ConnectionPoolError: Error {\n    case poolExhausted\n    case connectionNotFound\n    case invalidConnection\n}\n```\n\n### Caching Strategy\n\n```swift path=null start=null\nactor ResponseCache {\n    private var cache: [String: CacheEntry] = [:]\n    private let maxCacheSize: Int\n    private let defaultTTL: TimeInterval\n    private var cleanupTask: Task<Void, Never>?\n    \n    struct CacheEntry {\n        let data: Data\n        let expiry: Date\n        let accessCount: Int\n        let lastAccessed: Date\n        \n        var isExpired: Bool {\n            return Date() > expiry\n        }\n        \n        func accessed() -> CacheEntry {\n            return CacheEntry(\n                data: data,\n                expiry: expiry,\n                accessCount: accessCount + 1,\n                lastAccessed: Date()\n            )\n        }\n    }\n    \n    init(maxCacheSize: Int = 1000, defaultTTL: TimeInterval = 300) {\n        self.maxCacheSize = maxCacheSize\n        self.defaultTTL = defaultTTL\n        \n        startCleanupTask()\n    }\n    \n    func get<T: Codable>(_ key: String, type: T.Type) -> T? {\n        guard let entry = cache[key], !entry.isExpired else {\n            cache.removeValue(forKey: key)\n            return nil\n        }\n        \n        // Update access information\n        cache[key] = entry.accessed()\n        \n        do {\n            return try JSONDecoder().decode(type, from: entry.data)\n        } catch {\n            // Remove corrupted entry\n            cache.removeValue(forKey: key)\n            return nil\n        }\n    }\n    \n    func set<T: Codable>(_ key: String, value: T, ttl: TimeInterval? = nil) {\n        do {\n            let data = try JSONEncoder().encode(value)\n            let expiry = Date().addingTimeInterval(ttl ?? defaultTTL)\n            \n            let entry = CacheEntry(\n                data: data,\n                expiry: expiry,\n                accessCount: 0,\n                lastAccessed: Date()\n            )\n            \n            cache[key] = entry\n            \n            // Evict oldest entries if cache is full\n            if cache.count > maxCacheSize {\n                evictLeastRecentlyUsed()\n            }\n            \n        } catch {\n            print(\"Failed to cache value for key \\(key): \\(error)\")\n        }\n    }\n    \n    func remove(_ key: String) {\n        cache.removeValue(forKey: key)\n    }\n    \n    func clear() {\n        cache.removeAll()\n    }\n    \n    private func evictLeastRecentlyUsed() {\n        // Remove 20% of least recently used entries\n        let countToRemove = max(1, cache.count / 5)\n        \n        let sortedEntries = cache.sorted { first, second in\n            first.value.lastAccessed < second.value.lastAccessed\n        }\n        \n        for i in 0..<countToRemove {\n            cache.removeValue(forKey: sortedEntries[i].key)\n        }\n    }\n    \n    private func startCleanupTask() {\n        cleanupTask = Task {\n            while !Task.isCancelled {\n                try? await Task.sleep(nanoseconds: 60_000_000_000) // 1 minute\n                await cleanup()\n            }\n        }\n    }\n    \n    private func cleanup() {\n        let expiredKeys = cache.compactMap { key, entry in\n            entry.isExpired ? key : nil\n        }\n        \n        for key in expiredKeys {\n            cache.removeValue(forKey: key)\n        }\n    }\n    \n    var cacheStatistics: CacheStatistics {\n        let now = Date()\n        let expired = cache.values.filter { $0.isExpired }.count\n        let totalSize = cache.values.reduce(0) { $0 + $1.data.count }\n        \n        return CacheStatistics(\n            totalEntries: cache.count,\n            expiredEntries: expired,\n            maxSize: maxCacheSize,\n            totalSizeBytes: totalSize,\n            hitRate: calculateHitRate()\n        )\n    }\n    \n    private func calculateHitRate() -> Double {\n        let totalAccesses = cache.values.reduce(0) { $0 + $1.accessCount }\n        let uniqueEntries = cache.count\n        \n        guard totalAccesses > 0 else { return 0.0 }\n        \n        return Double(totalAccesses - uniqueEntries) / Double(totalAccesses)\n    }\n    \n    deinit {\n        cleanupTask?.cancel()\n    }\n}\n\nstruct CacheStatistics {\n    let totalEntries: Int\n    let expiredEntries: Int\n    let maxSize: Int\n    let totalSizeBytes: Int\n    let hitRate: Double\n    \n    var utilizationPercentage: Double {\n        return Double(totalEntries) / Double(maxSize) * 100.0\n    }\n}\n```\n\n## Monitoring and Observability\n\n### Metrics Collection\n\n```swift path=null start=null\nactor MetricsCollector {\n    private var metrics: [String: Metric] = [:]\n    private let flushInterval: TimeInterval\n    private var flushTask: Task<Void, Never>?\n    \n    enum MetricType {\n        case counter\n        case gauge\n        case histogram\n        case timer\n    }\n    \n    struct Metric {\n        let type: MetricType\n        let name: String\n        let tags: [String: String]\n        var values: [Double] = []\n        var timestamp: Date = Date()\n        \n        var currentValue: Double {\n            switch type {\n            case .counter:\n                return values.reduce(0, +)\n            case .gauge:\n                return values.last ?? 0\n            case .histogram, .timer:\n                return values.isEmpty ? 0 : values.reduce(0, +) / Double(values.count)\n            }\n        }\n    }\n    \n    init(flushInterval: TimeInterval = 60.0) {\n        self.flushInterval = flushInterval\n        startFlushTask()\n    }\n    \n    func increment(_ name: String, tags: [String: String] = [:], value: Double = 1.0) {\n        let key = metricKey(name, tags: tags)\n        \n        if var metric = metrics[key] {\n            metric.values.append(value)\n            metric.timestamp = Date()\n            metrics[key] = metric\n        } else {\n            metrics[key] = Metric(\n                type: .counter,\n                name: name,\n                tags: tags,\n                values: [value]\n            )\n        }\n    }\n    \n    func gauge(_ name: String, tags: [String: String] = [:], value: Double) {\n        let key = metricKey(name, tags: tags)\n        \n        metrics[key] = Metric(\n            type: .gauge,\n            name: name,\n            tags: tags,\n            values: [value]\n        )\n    }\n    \n    func histogram(_ name: String, tags: [String: String] = [:], value: Double) {\n        let key = metricKey(name, tags: tags)\n        \n        if var metric = metrics[key] {\n            metric.values.append(value)\n            metric.timestamp = Date()\n            metrics[key] = metric\n        } else {\n            metrics[key] = Metric(\n                type: .histogram,\n                name: name,\n                tags: tags,\n                values: [value]\n            )\n        }\n    }\n    \n    func timer<T>(_ name: String, tags: [String: String] = [:], operation: () async throws -> T) async rethrows -> T {\n        let startTime = Date()\n        let result = try await operation()\n        let duration = Date().timeIntervalSince(startTime)\n        \n        let key = metricKey(name, tags: tags)\n        \n        if var metric = metrics[key] {\n            metric.values.append(duration)\n            metric.timestamp = Date()\n            metrics[key] = metric\n        } else {\n            metrics[key] = Metric(\n                type: .timer,\n                name: name,\n                tags: tags,\n                values: [duration]\n            )\n        }\n        \n        return result\n    }\n    \n    func getMetrics() -> [Metric] {\n        return Array(metrics.values)\n    }\n    \n    func reset() {\n        metrics.removeAll()\n    }\n    \n    private func metricKey(_ name: String, tags: [String: String]) -> String {\n        let tagString = tags.sorted { $0.key < $1.key }\n            .map { \"\\($0.key)=\\($0.value)\" }\n            .joined(separator: \",\")\n        \n        return tagString.isEmpty ? name : \"\\(name){\\(tagString)}\"\n    }\n    \n    private func startFlushTask() {\n        flushTask = Task {\n            while !Task.isCancelled {\n                try? await Task.sleep(nanoseconds: UInt64(flushInterval * 1_000_000_000))\n                await flushMetrics()\n            }\n        }\n    }\n    \n    private func flushMetrics() {\n        let currentMetrics = getMetrics()\n        \n        // In a real implementation, you would send these to your monitoring system\n        // e.g., StatsD, Prometheus, CloudWatch, etc.\n        for metric in currentMetrics {\n            print(\"[METRICS] \\(metric.name): \\(metric.currentValue) (\\(metric.type))\")\n        }\n    }\n    \n    deinit {\n        flushTask?.cancel()\n    }\n}\n\n// Usage example with OgmiosClient\nclass InstrumentedOgmiosService {\n    private let client: OgmiosClient\n    private let metrics: MetricsCollector\n    \n    init(client: OgmiosClient, metrics: MetricsCollector) {\n        self.client = client\n        self.metrics = metrics\n    }\n    \n    func getCurrentTip() async throws -> TipResult {\n        return try await metrics.timer(\"ogmios.ledger_query.tip\", tags: [\"method\": \"tip\"]) {\n            do {\n                let response = try await client.ledgerStateQuery.tip.execute()\n                await metrics.increment(\"ogmios.requests.success\", tags: [\"method\": \"tip\"])\n                return response.result\n            } catch {\n                await metrics.increment(\"ogmios.requests.error\", tags: [\"method\": \"tip\", \"error\": String(describing: error)])\n                throw error\n            }\n        }\n    }\n    \n    func getProtocolParameters() async throws -> ProtocolParameters {\n        return try await metrics.timer(\"ogmios.ledger_query.protocol_parameters\", tags: [\"method\": \"protocolParameters\"]) {\n            do {\n                let response = try await client.ledgerStateQuery.protocolParameters.execute()\n                await metrics.increment(\"ogmios.requests.success\", tags: [\"method\": \"protocolParameters\"])\n                return response.result\n            } catch {\n                await metrics.increment(\"ogmios.requests.error\", tags: [\"method\": \"protocolParameters\", \"error\": String(describing: error)])\n                throw error\n            }\n        }\n    }\n}\n```\n\n### Health Monitoring\n\n```swift path=null start=null\nactor HealthMonitor {\n    private var healthChecks: [String: HealthCheck] = [:]\n    private let checkInterval: TimeInterval\n    private var monitoringTask: Task<Void, Never>?\n    private var healthStatus: [String: HealthStatus] = [:]\n    \n    enum HealthStatus {\n        case healthy\n        case degraded(String)\n        case unhealthy(String)\n        \n        var isHealthy: Bool {\n            switch self {\n            case .healthy:\n                return true\n            default:\n                return false\n            }\n        }\n    }\n    \n    struct HealthCheck {\n        let name: String\n        let check: () async -> HealthStatus\n        let timeout: TimeInterval\n        let criticalForOverall: Bool\n    }\n    \n    init(checkInterval: TimeInterval = 30.0) {\n        self.checkInterval = checkInterval\n        startMonitoring()\n    }\n    \n    func addHealthCheck(\n        name: String,\n        timeout: TimeInterval = 10.0,\n        criticalForOverall: Bool = true,\n        check: @escaping () async -> HealthStatus\n    ) {\n        healthChecks[name] = HealthCheck(\n            name: name,\n            check: check,\n            timeout: timeout,\n            criticalForOverall: criticalForOverall\n        )\n    }\n    \n    func removeHealthCheck(name: String) {\n        healthChecks.removeValue(forKey: name)\n        healthStatus.removeValue(forKey: name)\n    }\n    \n    func getHealthStatus() -> OverallHealthStatus {\n        let criticalChecks = healthStatus.filter { key, _ in\n            healthChecks[key]?.criticalForOverall == true\n        }\n        \n        let unhealthyCritical = criticalChecks.values.contains { !$0.isHealthy }\n        let overallStatus: HealthStatus\n        \n        if unhealthyCritical {\n            overallStatus = .unhealthy(\"One or more critical health checks failed\")\n        } else if healthStatus.values.contains(where: { !$0.isHealthy }) {\n            overallStatus = .degraded(\"Some non-critical health checks failed\")\n        } else {\n            overallStatus = .healthy\n        }\n        \n        return OverallHealthStatus(\n            overall: overallStatus,\n            checks: healthStatus\n        )\n    }\n    \n    private func startMonitoring() {\n        monitoringTask = Task {\n            while !Task.isCancelled {\n                await performHealthChecks()\n                try? await Task.sleep(nanoseconds: UInt64(checkInterval * 1_000_000_000))\n            }\n        }\n    }\n    \n    private func performHealthChecks() {\n        for (name, healthCheck) in healthChecks {\n            Task {\n                let status = await withTimeout(healthCheck.timeout) {\n                    await healthCheck.check()\n                } ?? .unhealthy(\"Health check timed out\")\n                \n                await updateHealthStatus(name: name, status: status)\n            }\n        }\n    }\n    \n    private func updateHealthStatus(name: String, status: HealthStatus) {\n        healthStatus[name] = status\n    }\n    \n    private func withTimeout<T>(\n        _ timeout: TimeInterval,\n        operation: @escaping () async -> T\n    ) async -> T? {\n        return try? await withThrowingTaskGroup(of: T?.self) { group in\n            group.addTask {\n                await operation()\n            }\n            \n            group.addTask {\n                try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))\n                return nil\n            }\n            \n            for try await result in group {\n                group.cancelAll()\n                return result\n            }\n            \n            return nil\n        }\n    }\n    \n    deinit {\n        monitoringTask?.cancel()\n    }\n}\n\nstruct OverallHealthStatus {\n    let overall: HealthMonitor.HealthStatus\n    let checks: [String: HealthMonitor.HealthStatus]\n    \n    var isHealthy: Bool {\n        return overall.isHealthy\n    }\n}\n\n// Example health checks for OgmiosClient\nextension HealthMonitor {\n    static func createOgmiosHealthChecks(client: OgmiosClient) -> [String: () async -> HealthStatus] {\n        return [\n            \"ogmios_connectivity\": {\n                do {\n                    _ = try await client.ledgerStateQuery.tip.execute()\n                    return .healthy\n                } catch {\n                    return .unhealthy(\"Cannot connect to Ogmios: \\(error.localizedDescription)\")\n                }\n            },\n            \n            \"ogmios_response_time\": {\n                let startTime = Date()\n                do {\n                    _ = try await client.ledgerStateQuery.tip.execute()\n                    let responseTime = Date().timeIntervalSince(startTime)\n                    \n                    if responseTime > 10.0 {\n                        return .unhealthy(\"Response time too high: \\(responseTime)s\")\n                    } else if responseTime > 5.0 {\n                        return .degraded(\"Response time elevated: \\(responseTime)s\")\n                    } else {\n                        return .healthy\n                    }\n                } catch {\n                    return .unhealthy(\"Health check failed: \\(error.localizedDescription)\")\n                }\n            },\n            \n            \"chain_sync_status\": {\n                do {\n                    let tip = try await client.ledgerStateQuery.tip.execute()\n                    let currentTime = Date().timeIntervalSince1970\n                    let slotTime = Double(tip.result.slot) // Simplified - actual slot time calculation more complex\n                    \n                    // Check if chain tip is recent (within last 5 minutes)\n                    let timeDiff = abs(currentTime - slotTime)\n                    if timeDiff > 300 { // 5 minutes\n                        return .degraded(\"Chain tip appears stale (\\(Int(timeDiff))s behind)\")\n                    } else {\n                        return .healthy\n                    }\n                } catch {\n                    return .unhealthy(\"Cannot check chain sync status: \\(error.localizedDescription)\")\n                }\n            }\n        ]\n    }\n}\n```\n\n## Production Deployment Patterns\n\n### Configuration Management\n\n```swift path=null start=null\nstruct OgmiosConfiguration {\n    // Connection settings\n    let hosts: [EndpointConfiguration]\n    let connectionTimeout: TimeInterval\n    let requestTimeout: TimeInterval\n    let maxRetries: Int\n    \n    // Transport settings\n    let preferredTransport: TransportType\n    let fallbackTransport: TransportType?\n    let keepAliveInterval: TimeInterval\n    \n    // Performance settings\n    let maxConcurrentRequests: Int\n    let connectionPoolSize: Int\n    let rateLimitInterval: TimeInterval\n    \n    // Caching settings\n    let cacheEnabled: Bool\n    let cacheSize: Int\n    let cacheTTL: TimeInterval\n    \n    // Monitoring settings\n    let metricsEnabled: Bool\n    let healthCheckInterval: TimeInterval\n    let logLevel: LogLevel\n    \n    enum TransportType {\n        case http\n        case webSocket\n    }\n    \n    enum LogLevel: String, CaseIterable {\n        case debug = \"debug\"\n        case info = \"info\"\n        case warning = \"warning\"\n        case error = \"error\"\n    }\n    \n    struct EndpointConfiguration {\n        let host: String\n        let port: Int\n        let secure: Bool\n        let priority: Int // Lower numbers = higher priority\n        let weight: Int   // For load balancing\n    }\n    \n    static func load(from path: String) throws -> OgmiosConfiguration {\n        let data = try Data(contentsOf: URL(fileURLWithPath: path))\n        return try JSONDecoder().decode(OgmiosConfiguration.self, from: data)\n    }\n    \n    static func load(from environment: [String: String] = ProcessInfo.processInfo.environment) -> OgmiosConfiguration {\n        return OgmiosConfiguration(\n            hosts: parseHosts(from: environment),\n            connectionTimeout: TimeInterval(environment[\"OGMIOS_CONNECTION_TIMEOUT\"] ?? \"30\") ?? 30,\n            requestTimeout: TimeInterval(environment[\"OGMIOS_REQUEST_TIMEOUT\"] ?? \"60\") ?? 60,\n            maxRetries: Int(environment[\"OGMIOS_MAX_RETRIES\"] ?? \"3\") ?? 3,\n            preferredTransport: TransportType(rawValue: environment[\"OGMIOS_TRANSPORT\"] ?? \"webSocket\") ?? .webSocket,\n            fallbackTransport: TransportType(rawValue: environment[\"OGMIOS_FALLBACK_TRANSPORT\"] ?? \"http\"),\n            keepAliveInterval: TimeInterval(environment[\"OGMIOS_KEEP_ALIVE\"] ?? \"60\") ?? 60,\n            maxConcurrentRequests: Int(environment[\"OGMIOS_MAX_CONCURRENT\"] ?? \"10\") ?? 10,\n            connectionPoolSize: Int(environment[\"OGMIOS_POOL_SIZE\"] ?? \"20\") ?? 20,\n            rateLimitInterval: TimeInterval(environment[\"OGMIOS_RATE_LIMIT\"] ?? \"0.1\") ?? 0.1,\n            cacheEnabled: environment[\"OGMIOS_CACHE_ENABLED\"] != \"false\",\n            cacheSize: Int(environment[\"OGMIOS_CACHE_SIZE\"] ?? \"1000\") ?? 1000,\n            cacheTTL: TimeInterval(environment[\"OGMIOS_CACHE_TTL\"] ?? \"300\") ?? 300,\n            metricsEnabled: environment[\"OGMIOS_METRICS_ENABLED\"] != \"false\",\n            healthCheckInterval: TimeInterval(environment[\"OGMIOS_HEALTH_CHECK_INTERVAL\"] ?? \"30\") ?? 30,\n            logLevel: LogLevel(rawValue: environment[\"OGMIOS_LOG_LEVEL\"] ?? \"info\") ?? .info\n        )\n    }\n    \n    private static func parseHosts(from environment: [String: String]) -> [EndpointConfiguration] {\n        guard let hostsString = environment[\"OGMIOS_HOSTS\"] else {\n            // Default configuration\n            return [\n                EndpointConfiguration(\n                    host: environment[\"OGMIOS_HOST\"] ?? \"localhost\",\n                    port: Int(environment[\"OGMIOS_PORT\"] ?? \"1337\") ?? 1337,\n                    secure: environment[\"OGMIOS_SECURE\"] == \"true\",\n                    priority: 1,\n                    weight: 1\n                )\n            ]\n        }\n        \n        // Parse comma-separated host list\n        // Format: \"host1:port1:secure:priority:weight,host2:port2:secure:priority:weight\"\n        return hostsString.split(separator: \",\").compactMap { hostString in\n            let components = hostString.split(separator: \":\").map(String.init)\n            guard components.count >= 2 else { return nil }\n            \n            return EndpointConfiguration(\n                host: components[0],\n                port: Int(components[1]) ?? 1337,\n                secure: components.count > 2 ? components[2] == \"true\" : false,\n                priority: components.count > 3 ? Int(components[3]) ?? 1 : 1,\n                weight: components.count > 4 ? Int(components[4]) ?? 1 : 1\n            )\n        }\n    }\n}\n\nextension OgmiosConfiguration.TransportType: RawRepresentable {\n    var rawValue: String {\n        switch self {\n        case .http:\n            return \"http\"\n        case .webSocket:\n            return \"webSocket\"\n        }\n    }\n    \n    init?(rawValue: String) {\n        switch rawValue.lowercased() {\n        case \"http\", \"https\":\n            self = .http\n        case \"websocket\", \"ws\", \"wss\":\n            self = .webSocket\n        default:\n            return nil\n        }\n    }\n}\n\nextension OgmiosConfiguration: Codable {}\nextension OgmiosConfiguration.EndpointConfiguration: Codable {}\n```\n\n### Production-Ready Client Factory\n\n```swift path=null start=null\nclass OgmiosClientFactory {\n    private let configuration: OgmiosConfiguration\n    private let connectionPool: ConnectionPool\n    private let metrics: MetricsCollector\n    private let healthMonitor: HealthMonitor\n    private let cache: ResponseCache\n    private let requestQueue: RequestQueue\n    \n    init(configuration: OgmiosConfiguration) {\n        self.configuration = configuration\n        self.connectionPool = ConnectionPool(maxPoolSize: configuration.connectionPoolSize)\n        self.metrics = MetricsCollector()\n        self.healthMonitor = HealthMonitor(checkInterval: configuration.healthCheckInterval)\n        self.cache = ResponseCache(\n            maxCacheSize: configuration.cacheSize,\n            defaultTTL: configuration.cacheTTL\n        )\n        self.requestQueue = RequestQueue(\n            maxConcurrentRequests: configuration.maxConcurrentRequests,\n            rateLimitInterval: configuration.rateLimitInterval\n        )\n        \n        setupHealthChecks()\n    }\n    \n    func createClient() async throws -> ProductionOgmiosClient {\n        let endpoint = try selectBestEndpoint()\n        let (connectionId, client) = try await connectionPool.borrowConnection(for: endpoint)\n        \n        return ProductionOgmiosClient(\n            client: client,\n            connectionId: connectionId,\n            endpoint: endpoint,\n            connectionPool: connectionPool,\n            metrics: metrics,\n            cache: configuration.cacheEnabled ? cache : nil,\n            requestQueue: requestQueue,\n            configuration: configuration\n        )\n    }\n    \n    private func selectBestEndpoint() throws -> Endpoint {\n        let sortedHosts = configuration.hosts.sorted { $0.priority < $1.priority }\n        \n        guard let host = sortedHosts.first else {\n            throw OgmiosClientError.noEndpointsAvailable\n        }\n        \n        return Endpoint(\n            host: host.host,\n            port: host.port,\n            secure: host.secure,\n            httpOnly: configuration.preferredTransport == .http\n        )\n    }\n    \n    private func setupHealthChecks() {\n        Task {\n            // Setup health checks would require a client, so we create a simple one\n            // In practice, you might want to create dedicated health check clients\n            do {\n                let endpoint = try selectBestEndpoint()\n                let healthClient = try await OgmiosClient(\n                    host: endpoint.host,\n                    port: endpoint.port,\n                    secure: endpoint.secure,\n                    httpOnly: endpoint.httpOnly\n                )\n                \n                let healthChecks = HealthMonitor.createOgmiosHealthChecks(client: healthClient)\n                \n                for (name, check) in healthChecks {\n                    await healthMonitor.addHealthCheck(name: name, check: check)\n                }\n            } catch {\n                print(\"Failed to setup health checks: \\(error)\")\n            }\n        }\n    }\n    \n    func getHealthStatus() async -> OverallHealthStatus {\n        return await healthMonitor.getHealthStatus()\n    }\n    \n    func getMetrics() async -> [MetricsCollector.Metric] {\n        return await metrics.getMetrics()\n    }\n}\n\nclass ProductionOgmiosClient {\n    private let client: OgmiosClient\n    private let connectionId: UUID\n    private let endpoint: Endpoint\n    private let connectionPool: ConnectionPool\n    private let metrics: MetricsCollector\n    private let cache: ResponseCache?\n    private let requestQueue: RequestQueue\n    private let configuration: OgmiosConfiguration\n    \n    init(\n        client: OgmiosClient,\n        connectionId: UUID,\n        endpoint: Endpoint,\n        connectionPool: ConnectionPool,\n        metrics: MetricsCollector,\n        cache: ResponseCache?,\n        requestQueue: RequestQueue,\n        configuration: OgmiosConfiguration\n    ) {\n        self.client = client\n        self.connectionId = connectionId\n        self.endpoint = endpoint\n        self.connectionPool = connectionPool\n        self.metrics = metrics\n        self.cache = cache\n        self.requestQueue = requestQueue\n        self.configuration = configuration\n    }\n    \n    func getTip() async throws -> TipResult {\n        return try await performCachedRequest(\n            key: \"tip\",\n            operation: {\n                let response = try await client.ledgerStateQuery.tip.execute()\n                return response.result\n            }\n        )\n    }\n    \n    func getProtocolParameters() async throws -> ProtocolParameters {\n        return try await performCachedRequest(\n            key: \"protocol_parameters\",\n            operation: {\n                let response = try await client.ledgerStateQuery.protocolParameters.execute()\n                return response.result\n            }\n        )\n    }\n    \n    private func performCachedRequest<T: Codable>(\n        key: String,\n        operation: @escaping () async throws -> T\n    ) async throws -> T {\n        // Check cache first\n        if let cache = cache,\n           let cached = await cache.get(key, type: T.self) {\n            await metrics.increment(\"ogmios.cache.hit\", tags: [\"key\": key])\n            return cached\n        }\n        \n        await metrics.increment(\"ogmios.cache.miss\", tags: [\"key\": key])\n        \n        // Execute request through queue with metrics\n        return try await requestQueue.enqueue {\n            try await metrics.timer(\"ogmios.request.duration\", tags: [\"key\": key]) {\n                do {\n                    let result = try await operation()\n                    \n                    // Cache result\n                    if let cache = cache {\n                        await cache.set(key, value: result)\n                    }\n                    \n                    await metrics.increment(\"ogmios.request.success\", tags: [\"key\": key])\n                    return result\n                } catch {\n                    await metrics.increment(\"ogmios.request.error\", tags: [\"key\": key, \"error\": String(describing: error)])\n                    throw error\n                }\n            }\n        }\n    }\n    \n    deinit {\n        Task {\n            await connectionPool.returnConnection(connectionId, client: client, endpoint: endpoint)\n        }\n    }\n}\n\nenum OgmiosClientError: Error {\n    case noEndpointsAvailable\n    case allEndpointsUnhealthy\n    case configurationError(String)\n}\n```\n\n## Best Practices Summary\n\n### Testing Best Practices\n\n1. **Use Protocol-Based Design**: Create protocols for testable interfaces\n2. **Mock External Dependencies**: Use mock clients for unit testing\n3. **Test Error Scenarios**: Verify error handling and recovery paths\n4. **Performance Testing**: Include performance benchmarks in your test suite\n5. **Integration Testing**: Test against real Ogmios servers in CI/CD\n\n### Concurrency Best Practices\n\n1. **Use Actors for State Management**: Protect shared state with actors\n2. **Implement Rate Limiting**: Respect server limits with request queuing\n3. **Connection Pooling**: Reuse connections for better performance\n4. **Batch Processing**: Group related operations for efficiency\n5. **Timeout Handling**: Implement timeouts for all async operations\n\n### Performance Best Practices\n\n1. **Caching Strategy**: Cache frequently accessed data with appropriate TTL\n2. **Connection Reuse**: Pool connections to avoid overhead\n3. **Concurrent Operations**: Use TaskGroup for parallel execution\n4. **Memory Management**: Monitor and optimize memory usage\n5. **Resource Cleanup**: Properly clean up resources in deinit\n\n### Production Best Practices\n\n1. **Configuration Management**: Externalize all configuration\n2. **Health Monitoring**: Implement comprehensive health checks\n3. **Metrics Collection**: Track performance and error metrics\n4. **Logging**: Implement structured logging with appropriate levels\n5. **Error Handling**: Provide detailed error information and recovery strategies\n6. **Circuit Breaker**: Implement circuit breaker pattern for resilience\n7. **Documentation**: Document configuration options and deployment procedures\n\n## See Also\n\n- <doc:GettingStarted> - Basic setup and configuration\n- <doc:ErrorHandling> - Comprehensive error handling strategies\n- <doc:TransportTypes> - Transport optimization for performance\n- <doc:ChainSynchronization> - Real-time blockchain data processing\n- <doc:TransactionSubmission> - Production transaction handling patterns