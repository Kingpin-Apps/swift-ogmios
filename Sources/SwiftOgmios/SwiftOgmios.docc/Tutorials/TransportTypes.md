# Transport Types

Understand HTTP vs WebSocket transports, optimize for security and performance, and implement best practices for mobile applications.

## Overview

SwiftOgmios supports both HTTP/HTTPS and WebSocket/WSS transport protocols, each with distinct advantages and use cases. This tutorial covers when to use each transport type, security considerations, performance optimization, and mobile-specific best practices.

Understanding transport types is crucial for building efficient, secure, and battery-friendly Cardano applications.

## Transport Comparison

| Feature | HTTP/HTTPS | WebSocket/WSS |
|---------|------------|---------------|
| **Connection Model** | Request-Response | Persistent Bidirectional |
| **Best For** | Simple queries, occasional use | Real-time monitoring, continuous data |
| **Battery Impact** | Lower (intermittent connections) | Higher (persistent connections) |
| **Latency** | Higher (connection overhead) | Lower (connection reuse) |
| **Throughput** | Lower | Higher for multiple requests |
| **Complexity** | Simple | More complex |
| **Error Handling** | Simpler | More sophisticated required |
| **Mobile Networks** | More resilient to network changes | Sensitive to network interruptions |

## HTTP/HTTPS Transport

### When to Use HTTP Transport

HTTP transport is ideal for:
- **Simple Queries**: One-off ledger state queries
- **Occasional Updates**: Periodic data fetching
- **Mobile Applications**: Battery-sensitive applications
- **Unreliable Networks**: Applications that frequently switch networks
- **Simple Architecture**: When you don't need real-time updates

### Basic HTTP Usage

```swift path=null start=null
import SwiftOgmios

// Create HTTP client
let httpClient = try await OgmiosClient(
    host: "localhost",
    port: 1337,
    secure: false,      // Use HTTP
    httpOnly: true      // Force HTTP transport
)

// Perform simple queries
let epochResponse = try await httpClient.ledgerStateQuery.epoch.execute()
print("Current epoch: \(epochResponse.result)")

// HTTP is automatically closed after each request
// No need to manage persistent connections
```

### HTTPS for Production

```swift path=null start=null
// Production HTTPS client
let httpsClient = try await OgmiosClient(
    host: "your-ogmios-server.com",
    port: 443,
    secure: true,       // Use HTTPS
    httpOnly: true      // Force HTTPS transport
)

// All communication is encrypted via TLS
let tipResponse = try await httpsClient.ledgerStateQuery.tip.execute()
print("Secure tip query: \(tipResponse.result)")
```

### HTTP Performance Optimization

```swift path=null start=null
class OptimizedHTTPClient {
    private let client: OgmiosClient
    private let session: URLSession
    
    init(host: String, port: Int, secure: Bool = true) async throws {
        // Configure optimized URLSession
        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 6
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        config.requestCachePolicy = .useProtocolCachePolicy
        
        // Enable HTTP/2 and connection reuse
        config.httpShouldUsePipelining = true
        config.urlCache = URLCache(memoryCapacity: 4 * 1024 * 1024, // 4MB
                                   diskCapacity: 20 * 1024 * 1024)    // 20MB
        
        self.session = URLSession(configuration: config)
        self.client = try await OgmiosClient(
            host: host,
            port: port,
            secure: secure,
            httpOnly: true,
            configuration: config
        )
    }
    
    func batchQueries() async throws {
        // Execute multiple queries concurrently
        async let epochTask = client.ledgerStateQuery.epoch.execute()
        async let tipTask = client.ledgerStateQuery.tip.execute()
        async let poolsTask = client.ledgerStateQuery.stakePools.execute()
        
        let (epochResponse, tipResponse, poolsResponse) = try await (epochTask, tipTask, poolsTask)
        
        print("Batch results:")
        print("  Epoch: \(epochResponse.result)")
        print("  Tip: \(tipResponse.result.slot)")
        print("  Pools: \(poolsResponse.result.count)")
    }
}
```

## WebSocket Transport

### When to Use WebSocket Transport

WebSocket transport excels for:
- **Real-Time Applications**: Chain sync, mempool monitoring
- **High-Frequency Queries**: Many requests over time
- **Bidirectional Communication**: When server needs to push data
- **Low Latency Requirements**: Gaming, trading applications
- **Persistent Connections**: Long-running applications

### Basic WebSocket Usage

```swift path=null start=null
// Create WebSocket client
let wsClient = try await OgmiosClient(
    host: "localhost",
    port: 1337,
    secure: false,      // Use WS
    httpOnly: false     // Use WebSocket transport
)

// Connection remains open for multiple requests
let epochResponse = try await wsClient.ledgerStateQuery.epoch.execute()
let tipResponse = try await wsClient.ledgerStateQuery.tip.execute()

// WebSocket connection is reused automatically
print("Epoch: \(epochResponse.result)")
print("Tip: \(tipResponse.result.slot)")

// Remember to clean up when done (handled automatically by deinit)
```

### WSS for Production

```swift path=null start=null
// Production WSS client with enhanced security
let wssClient = try await OgmiosClient(
    host: "secure-ogmios-server.com",
    port: 443,
    secure: true,       // Use WSS (WebSocket Secure)
    httpOnly: false
)

// All WebSocket communication is encrypted via TLS
```

### WebSocket Connection Management

```swift path=null start=null
actor WebSocketManager {
    private var client: OgmiosClient?
    private let config: ConnectionConfig
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5
    private var heartbeatTask: Task<Void, Never>?
    
    struct ConnectionConfig {
        let host: String
        let port: Int
        let secure: Bool
        let heartbeatInterval: TimeInterval = 30.0
        let reconnectDelay: TimeInterval = 5.0
    }
    
    init(config: ConnectionConfig) {
        self.config = config
    }
    
    func connect() async throws {
        guard client == nil else { return }
        
        do {
            client = try await OgmiosClient(
                host: config.host,
                port: config.port,
                secure: config.secure,
                httpOnly: false
            )
            
            reconnectAttempts = 0
            startHeartbeat()
            print("WebSocket connected successfully")
            
        } catch {
            print("Connection failed: \(error)")
            await scheduleReconnect()
            throw error
        }
    }
    
    func disconnect() {
        heartbeatTask?.cancel()
        client = nil
        print("WebSocket disconnected")
    }
    
    func execute<T>(_ operation: (OgmiosClient) async throws -> T) async throws -> T {
        guard let client = client else {
            throw TransportError.notConnected
        }
        
        do {
            return try await operation(client)
        } catch {
            print("Operation failed: \(error)")
            
            // Check if we need to reconnect
            if shouldReconnectOnError(error) {
                await scheduleReconnect()
            }
            
            throw error
        }
    }
    
    private func startHeartbeat() {
        heartbeatTask = Task { [weak self] in
            while !Task.isCancelled {
                do {
                    try await Task.sleep(nanoseconds: UInt64(config.heartbeatInterval * 1_000_000_000))
                    await self?.performHeartbeat()
                } catch {
                    break
                }
            }
        }
    }
    
    private func performHeartbeat() async {
        do {
            _ = try await client?.ledgerStateQuery.tip.execute()
        } catch {
            print("Heartbeat failed: \(error)")
            await scheduleReconnect()
        }
    }
    
    private func scheduleReconnect() async {
        guard reconnectAttempts < maxReconnectAttempts else {
            print("Max reconnect attempts exceeded")
            return
        }
        
        reconnectAttempts += 1
        disconnect()
        
        print("Reconnecting in \(config.reconnectDelay) seconds (attempt \(reconnectAttempts))")
        
        try? await Task.sleep(nanoseconds: UInt64(config.reconnectDelay * 1_000_000_000))
        
        do {
            try await connect()
        } catch {
            print("Reconnect failed: \(error)")
        }
    }
    
    private func shouldReconnectOnError(_ error: Error) -> Bool {
        switch error {
        case OgmiosError.websocketError(_),
             OgmiosError.httpError(_):
            return true
        default:
            return false
        }
    }
}

enum TransportError: Error {
    case notConnected
    case connectionLost
    case reconnectFailed
}

// Usage
let manager = WebSocketManager(config: WebSocketManager.ConnectionConfig(
    host: "localhost",
    port: 1337,
    secure: false
))

try await manager.connect()

let epoch = try await manager.execute { client in
    return try await client.ledgerStateQuery.epoch.execute()
}

print("Current epoch: \(epoch.result)")
```

## Security Considerations

### TLS Configuration

```swift path=null start=null
class SecureTransportClient {
    static func createSecureClient(
        host: String,
        port: Int,
        certificatePinning: Bool = false
    ) async throws -> OgmiosClient {
        
        let config = URLSessionConfiguration.default
        
        // Enhanced security settings
        config.tlsMinimumSupportedProtocolVersion = .TLSv12
        config.tlsMaximumSupportedProtocolVersion = .TLSv13
        
        if certificatePinning {
            // Implement certificate pinning for enhanced security
            config.urlSessionDidReceiveChallenge = { session, challenge in
                return await handleCertificateChallenge(challenge)
            }
        }
        
        // Disable insecure connections
        config.httpShouldUsePipelining = false
        config.httpCookieAcceptPolicy = .never
        
        return try await OgmiosClient(
            host: host,
            port: port,
            secure: true, // Always use TLS in production
            httpOnly: false,
            configuration: config
        )
    }
    
    private static func handleCertificateChallenge(
        _ challenge: URLAuthenticationChallenge
    ) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        
        // Implement certificate pinning logic
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return (.cancelAuthenticationChallenge, nil)
        }
        
        // Validate certificate against pinned certificates
        // This is a simplified example - implement proper certificate validation
        let credential = URLCredential(trust: serverTrust)
        return (.useCredential, credential)
    }
}

// Usage
let secureClient = try await SecureTransportClient.createSecureClient(
    host: "production-ogmios.example.com",
    port: 443,
    certificatePinning: true
)
```

### Authentication and Authorization

```swift path=null start=null
class AuthenticatedOgmiosClient {
    private let baseClient: OgmiosClient
    private let apiKey: String
    
    init(host: String, port: Int, apiKey: String) async throws {
        self.apiKey = apiKey
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "User-Agent": "SwiftOgmios/1.0.0",
            "Accept": "application/json"
        ]
        
        self.baseClient = try await OgmiosClient(
            host: host,
            port: port,
            secure: true,
            httpOnly: true,
            configuration: config
        )
    }
    
    func authenticatedQuery<T: JSONRPCResponse>(
        _ operation: (OgmiosClient) async throws -> T
    ) async throws -> T {
        do {
            return try await operation(baseClient)
        } catch OgmiosError.httpError(let message) where message.contains("401") {
            throw AuthenticationError.invalidCredentials
        } catch OgmiosError.httpError(let message) where message.contains("403") {
            throw AuthenticationError.accessDenied
        } catch {
            throw error
        }
    }
}

enum AuthenticationError: Error, LocalizedError {
    case invalidCredentials
    case accessDenied
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid API credentials"
        case .accessDenied:
            return "Access denied - insufficient permissions"
        }
    }
}
```

## Mobile Optimization

### Battery-Efficient Patterns

```swift path=null start=null
@MainActor
class MobileOptimizedClient: ObservableObject {
    @Published var connectionState: ConnectionState = .disconnected
    @Published var isBackgroundMode = false
    
    private var client: OgmiosClient?
    private let config: MobileConfig
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    enum ConnectionState {
        case disconnected
        case connecting
        case connected
        case backgrounded
    }
    
    struct MobileConfig {
        let useHTTPInBackground: Bool = true
        let backgroundSyncInterval: TimeInterval = 300 // 5 minutes
        let foregroundSyncInterval: TimeInterval = 30  // 30 seconds
        let batteryOptimizationEnabled: Bool = true
    }
    
    init(config: MobileConfig = MobileConfig()) {
        self.config = config
        setupAppLifecycleObservers()
    }
    
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc private func appDidEnterBackground() {
        isBackgroundMode = true
        
        if config.useHTTPInBackground {
            // Switch to HTTP for background mode
            Task {
                await switchToBackgroundMode()
            }
        }
    }
    
    @objc private func appWillEnterForeground() {
        isBackgroundMode = false
        endBackgroundTask()
        
        Task {
            await switchToForegroundMode()
        }
    }
    
    private func switchToBackgroundMode() async {
        beginBackgroundTask()
        
        // Close WebSocket connections to save battery
        client = nil
        connectionState = .backgrounded
        
        // Create HTTP client for occasional background updates
        do {
            client = try await OgmiosClient(
                host: "your-server.com",
                port: 443,
                secure: true,
                httpOnly: true
            )
        } catch {
            print("Failed to create background HTTP client: \(error)")
        }
    }
    
    private func switchToForegroundMode() async {
        connectionState = .connecting
        
        do {
            // Recreate WebSocket client for real-time updates
            client = try await OgmiosClient(
                host: "your-server.com",
                port: 443,
                secure: true,
                httpOnly: false
            )
            
            connectionState = .connected
        } catch {
            print("Failed to create foreground WebSocket client: \(error)")
            connectionState = .disconnected
        }
    }
    
    private func beginBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    func performOptimizedQuery<T>(
        _ operation: (OgmiosClient) async throws -> T
    ) async throws -> T {
        guard let client = client else {
            throw TransportError.notConnected
        }
        
        return try await operation(client)
    }
}
```

### Network Change Handling

```swift path=null start=null
import Network

class NetworkAwareClient: ObservableObject {
    @Published var networkStatus: NetworkStatus = .unknown
    @Published var connectionQuality: ConnectionQuality = .unknown
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var client: OgmiosClient?
    
    enum NetworkStatus {
        case unknown
        case unavailable
        case wifi
        case cellular
        case ethernet
    }
    
    enum ConnectionQuality {
        case unknown
        case poor
        case moderate
        case good
        case excellent
    }
    
    init() {
        startNetworkMonitoring()
    }
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.handleNetworkChange(path)
            }
        }
        monitor.start(queue: queue)
    }
    
    @MainActor
    private func handleNetworkChange(_ path: NWPath) {
        // Update network status
        if path.status == .satisfied {
            if path.usesInterfaceType(.wifi) {
                networkStatus = .wifi
                connectionQuality = .excellent
            } else if path.usesInterfaceType(.cellular) {
                networkStatus = .cellular
                connectionQuality = assessCellularQuality(path)
            } else if path.usesInterfaceType(.wiredEthernet) {
                networkStatus = .ethernet
                connectionQuality = .excellent
            }
        } else {
            networkStatus = .unavailable
            connectionQuality = .unknown
        }
        
        // Adapt transport based on network quality
        Task {
            await adaptTransportToNetwork()
        }
    }
    
    private func assessCellularQuality(_ path: NWPath) -> ConnectionQuality {
        // Simplified cellular quality assessment
        if path.isExpensive {
            return .moderate // Cellular data
        }
        return .good
    }
    
    private func adaptTransportToNetwork() async {
        let shouldUseHTTP = networkStatus == .cellular || connectionQuality == .poor
        
        do {
            client = try await OgmiosClient(
                host: "your-server.com",
                port: 443,
                secure: true,
                httpOnly: shouldUseHTTP
            )
            
            print("Adapted transport: \(shouldUseHTTP ? "HTTP" : "WebSocket") for \(networkStatus)")
            
        } catch {
            print("Failed to adapt transport: \(error)")
        }
    }
    
    deinit {
        monitor.cancel()
    }
}
```

## Performance Benchmarking

### Transport Performance Comparison

```swift path=null start=null
class TransportBenchmark {
    struct BenchmarkResult {
        let transportType: String
        let operationsPerSecond: Double
        let averageLatency: TimeInterval
        let totalTime: TimeInterval
        let successRate: Double
    }
    
    static func benchmarkTransports(
        host: String,
        port: Int,
        operations: Int = 100
    ) async throws -> [BenchmarkResult] {
        
        var results: [BenchmarkResult] = []
        
        // Benchmark HTTP
        let httpResult = try await benchmarkHTTP(
            host: host,
            port: port,
            operations: operations
        )
        results.append(httpResult)
        
        // Benchmark WebSocket
        let wsResult = try await benchmarkWebSocket(
            host: host,
            port: port,
            operations: operations
        )
        results.append(wsResult)
        
        return results
    }
    
    private static func benchmarkHTTP(
        host: String,
        port: Int,
        operations: Int
    ) async throws -> BenchmarkResult {
        
        let client = try await OgmiosClient(
            host: host,
            port: port,
            secure: false,
            httpOnly: true
        )
        
        let startTime = Date()
        var latencies: [TimeInterval] = []
        var successes = 0
        
        for _ in 0..<operations {
            let operationStart = Date()
            
            do {
                _ = try await client.ledgerStateQuery.tip.execute()
                let latency = Date().timeIntervalSince(operationStart)
                latencies.append(latency)
                successes += 1
            } catch {
                print("HTTP operation failed: \(error)")
            }
        }
        
        let totalTime = Date().timeIntervalSince(startTime)
        let averageLatency = latencies.reduce(0, +) / Double(latencies.count)
        let opsPerSecond = Double(successes) / totalTime
        let successRate = Double(successes) / Double(operations)
        
        return BenchmarkResult(
            transportType: "HTTP",
            operationsPerSecond: opsPerSecond,
            averageLatency: averageLatency,
            totalTime: totalTime,
            successRate: successRate
        )
    }
    
    private static func benchmarkWebSocket(
        host: String,
        port: Int,
        operations: Int
    ) async throws -> BenchmarkResult {
        
        let client = try await OgmiosClient(
            host: host,
            port: port,
            secure: false,
            httpOnly: false
        )
        
        let startTime = Date()
        var latencies: [TimeInterval] = []
        var successes = 0
        
        for _ in 0..<operations {
            let operationStart = Date()
            
            do {
                _ = try await client.ledgerStateQuery.tip.execute()
                let latency = Date().timeIntervalSince(operationStart)
                latencies.append(latency)
                successes += 1
            } catch {
                print("WebSocket operation failed: \(error)")
            }
        }
        
        let totalTime = Date().timeIntervalSince(startTime)
        let averageLatency = latencies.reduce(0, +) / Double(latencies.count)
        let opsPerSecond = Double(successes) / totalTime
        let successRate = Double(successes) / Double(operations)
        
        return BenchmarkResult(
            transportType: "WebSocket",
            operationsPerSecond: opsPerSecond,
            averageLatency: averageLatency,
            totalTime: totalTime,
            successRate: successRate
        )
    }
    
    static func printBenchmarkResults(_ results: [BenchmarkResult]) {
        print("\n📊 Transport Benchmark Results:")
        print("=" * 50)
        
        for result in results {
            print("\n\(result.transportType):")
            print("  Operations/sec: \(String(format: "%.2f", result.operationsPerSecond))")
            print("  Avg latency: \(String(format: "%.3f", result.averageLatency))s")
            print("  Total time: \(String(format: "%.2f", result.totalTime))s")
            print("  Success rate: \(String(format: "%.1f", result.successRate * 100))%")
        }
        
        if results.count >= 2 {
            let httpResult = results.first { $0.transportType == "HTTP" }!
            let wsResult = results.first { $0.transportType == "WebSocket" }!
            
            let speedupFactor = wsResult.operationsPerSecond / httpResult.operationsPerSecond
            let latencyImprovement = (httpResult.averageLatency - wsResult.averageLatency) / httpResult.averageLatency * 100
            
            print("\n🚀 Performance Comparison:")
            print("  WebSocket is \(String(format: "%.2f", speedupFactor))x faster")
            print("  WebSocket has \(String(format: "%.1f", latencyImprovement))% lower latency")
        }
    }
}

// Usage
let results = try await TransportBenchmark.benchmarkTransports(
    host: "localhost",
    port: 1337,
    operations: 50
)
TransportBenchmark.printBenchmarkResults(results)
```

## Best Practices Summary

### HTTP/HTTPS Best Practices

1. **Use for Simple Queries**: One-off requests and periodic updates
2. **Enable Connection Reuse**: Configure URLSession for connection pooling
3. **Implement Caching**: Use URLCache for appropriate responses
4. **Handle Timeouts**: Set reasonable timeout values
5. **Batch Concurrent Requests**: Use async/await for parallel queries
6. **Mobile Optimization**: Prefer HTTP for background operations

### WebSocket Best Practices

1. **Use for Real-Time Data**: Chain sync, mempool monitoring, live updates
2. **Implement Heartbeat**: Regular ping/pong to detect connection issues
3. **Handle Reconnection**: Automatic reconnection with exponential backoff
4. **Monitor Connection Health**: Track connection state and quality
5. **Graceful Degradation**: Fall back to HTTP when WebSocket fails
6. **Resource Management**: Properly close connections when not needed

### Security Best Practices

1. **Always Use TLS in Production**: HTTPS/WSS for encrypted communication
2. **Implement Certificate Pinning**: For enhanced security in sensitive applications
3. **Validate Server Identity**: Proper certificate validation
4. **Use Authentication**: API keys or tokens when required
5. **Monitor for Security Issues**: Log and alert on authentication failures
6. **Regular Security Updates**: Keep dependencies and certificates updated

### Mobile Best Practices

1. **Adapt to Network Conditions**: Switch transports based on connectivity
2. **Optimize for Battery**: Use HTTP in background, WebSocket in foreground
3. **Handle Network Changes**: Monitor and adapt to network state changes
4. **Implement Background Tasks**: Proper background execution handling
5. **Respect Data Usage**: Be mindful of cellular data consumption
6. **Test on Real Devices**: Verify performance across different network conditions

## See Also

- <doc:GettingStarted> - Basic setup and transport selection
- <doc:ErrorHandling> - Transport-specific error handling strategies
- <doc:ChainSynchronization> - WebSocket usage for real-time block streaming
- <doc:MempoolMonitoring> - Transport considerations for mempool monitoring
- <doc:AdvancedUsage> - Advanced transport patterns and optimization techniques