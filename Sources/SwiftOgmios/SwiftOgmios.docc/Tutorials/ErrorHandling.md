# Error Handling

Master robust error handling strategies for SwiftOgmios applications with comprehensive error taxonomy and recovery patterns.

## Overview

Robust error handling is crucial for building reliable Cardano applications. SwiftOgmios provides detailed error information with specific error codes and recovery strategies. This guide covers the complete error taxonomy, handling patterns, and best practices for building resilient applications.

## Error Taxonomy

SwiftOgmios defines several error categories to help you handle different failure scenarios appropriately.

### OgmiosError Types

```swift path=null start=null
public enum OgmiosError: LocalizedError, Sendable {
    case httpError(String)
    case websocketError(String) 
    case responseError(String)
    case invalidResponse(String)
    case timeoutError(String)
    case invalidFormat(String)
    case invalidMethodError(String)
}
```

#### Transport Errors

**HTTP Errors**: Connection and HTTP-specific failures
```swift path=null start=null
do {
    let response = try await client.ledgerStateQuery.epoch.execute()
} catch OgmiosError.httpError(let message) {
    print("HTTP connection failed: \(message)")
    // Handle: retry with backoff, switch to backup server, notify user
}
```

**WebSocket Errors**: WebSocket connection and communication failures
```swift path=null start=null
do {
    let response = try await client.chainSync.nextBlock.execute()
} catch OgmiosError.websocketError(let message) {
    print("WebSocket error: \(message)")
    // Handle: reconnect, fallback to HTTP, notify user of connection loss
}
```

#### Protocol Errors

**Response Errors**: Ogmios server returned an error response
```swift path=null start=null
do {
    let response = try await client.ledgerStateQuery.constitution.execute()
} catch OgmiosError.responseError(let message) {
    print("Server error: \(message)")
    // Parse error code for specific handling
    if message.contains("2001") {
        print("Era mismatch - query not available in current era")
    }
}
```

**Invalid Response**: Malformed or unexpected response format
```swift path=null start=null
do {
    let response = try await client.ledgerStateQuery.tip.execute()
} catch OgmiosError.invalidResponse(let message) {
    print("Invalid response format: \(message)")
    // Handle: log for debugging, retry, report to monitoring
}
```

#### Application Errors

**Timeout Errors**: Operations that exceed time limits
```swift path=null start=null
do {
    try await client.mempoolMonitor.waitForEmptyMempool(timeoutSeconds: 30.0)
} catch OgmiosError.timeoutError(let message) {
    print("Operation timed out: \(message)")
    // Handle: extend timeout, cancel operation, notify user
}
```

## JSON-RPC Error Codes

Ogmios follows JSON-RPC 2.0 specification and returns specific error codes:

### Ledger State Query Errors

| Code | Error | Description | Recovery Strategy |
|------|-------|-------------|-------------------|
| 2001 | Era Mismatch | Query not available in current era | Check current era, use compatible queries |
| 2002 | Unavailable in Current Era | Feature not available in current era | Wait for era transition or use alternatives |
| 2003 | Acquired Expired | Ledger state snapshot expired | Retry query to get fresh snapshot |

### Transaction Submission Errors

| Code | Error | Description | Recovery Strategy |
|------|-------|-------------|-------------------|
| 3005 | Era Mismatch | Transaction not valid in current era | Rebuild transaction for current era |
| 3100 | Invalid Signatures | Transaction signatures invalid | Re-sign transaction |
| 3101 | Missing Signatures | Required signatures missing | Add missing signatures |
| 3102 | Missing Scripts | Script witnesses missing | Add required script witnesses |
| 3122 | Fee Too Small | Insufficient transaction fee | Increase fee and resubmit |
| 3123 | Value Not Conserved | Input/output value mismatch | Fix transaction balance |

### Error Code Detection

```swift path=null start=null
extension OgmiosError {
    var errorCode: Int? {
        switch self {
        case .responseError(let message):
            // Extract error code from message
            let codeRegex = try! NSRegularExpression(pattern: #"(\d{4})"#)
            let range = NSRange(message.startIndex..<message.endIndex, in: message)
            
            if let match = codeRegex.firstMatch(in: message, options: [], range: range) {
                let codeRange = Range(match.range(at: 1), in: message)!
                return Int(String(message[codeRange]))
            }
            return nil
        default:
            return nil
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .httpError(_), .websocketError(_):
            return true // Network errors are typically retryable
        case .responseError(let message):
            // Some response errors are retryable
            guard let code = errorCode else { return false }
            return code == 2003 // Acquired expired
        case .timeoutError(_):
            return true
        default:
            return false
        }
    }
}
```

## Retry Strategies

### Basic Retry Pattern

```swift path=null start=null
func withRetry<T>(
    operation: @escaping () async throws -> T,
    maxAttempts: Int = 3,
    delay: TimeInterval = 1.0
) async throws -> T {
    var lastError: Error?
    
    for attempt in 1...maxAttempts {
        do {
            return try await operation()
        } catch let error as OgmiosError where error.isRetryable && attempt < maxAttempts {
            print("Attempt \(attempt) failed, retrying in \(delay)s: \(error.localizedDescription)")
            lastError = error
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        } catch {
            throw error // Non-retryable error or final attempt
        }
    }
    
    throw lastError ?? OgmiosError.responseError("Max attempts exceeded")
}

// Usage
let epochResponse = try await withRetry {
    return try await client.ledgerStateQuery.epoch.execute()
}
```

### Exponential Backoff

```swift path=null start=null
func withExponentialBackoff<T>(
    operation: @escaping () async throws -> T,
    maxAttempts: Int = 3,
    baseDelay: TimeInterval = 1.0,
    maxDelay: TimeInterval = 60.0
) async throws -> T {
    var lastError: Error?
    
    for attempt in 1...maxAttempts {
        do {
            return try await operation()
        } catch let error as OgmiosError where error.isRetryable && attempt < maxAttempts {
            let delay = min(baseDelay * pow(2.0, Double(attempt - 1)), maxDelay)
            print("Attempt \(attempt) failed, retrying in \(String(format: "%.1f", delay))s")
            
            lastError = error
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        } catch {
            throw error
        }
    }
    
    throw lastError ?? OgmiosError.responseError("Max attempts exceeded")
}
```

### Circuit Breaker Pattern

```swift path=null start=null
actor CircuitBreaker {
    enum State {
        case closed    // Normal operation
        case open      // Failing fast
        case halfOpen  // Testing recovery
    }
    
    private var state: State = .closed
    private var failureCount = 0
    private var lastFailureTime: Date?
    private let failureThreshold = 5
    private let timeout: TimeInterval = 30.0
    
    func execute<T>(_ operation: @escaping () async throws -> T) async throws -> T {
        switch state {
        case .open:
            if let lastFailure = lastFailureTime,
               Date().timeIntervalSince(lastFailure) > timeout {
                state = .halfOpen
            } else {
                throw OgmiosError.responseError("Circuit breaker is open")
            }
            
        case .halfOpen, .closed:
            break
        }
        
        do {
            let result = try await operation()
            await onSuccess()
            return result
        } catch {
            await onFailure()
            throw error
        }
    }
    
    private func onSuccess() {
        failureCount = 0
        state = .closed
    }
    
    private func onFailure() {
        failureCount += 1
        lastFailureTime = Date()
        
        if failureCount >= failureThreshold {
            state = .open
        }
    }
}

// Usage
let circuitBreaker = CircuitBreaker()

let response = try await circuitBreaker.execute {
    return try await client.ledgerStateQuery.epoch.execute()
}
```

## Comprehensive Error Handling Service

```swift path=null start=null
@MainActor
class OgmiosErrorHandler: ObservableObject {
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var lastError: OgmiosError?
    @Published var errorHistory: [ErrorRecord] = []
    
    enum ConnectionStatus {
        case connected
        case disconnected
        case reconnecting
        case failed
    }
    
    struct ErrorRecord {
        let error: OgmiosError
        let timestamp: Date
        let operation: String
    }
    
    private let maxErrorHistory = 100
    
    func handle(_ error: Error, operation: String) {
        guard let ogmiosError = error as? OgmiosError else {
            print("Non-Ogmios error: \(error)")
            return
        }
        
        let record = ErrorRecord(
            error: ogmiosError,
            timestamp: Date(),
            operation: operation
        )
        
        // Update published properties
        lastError = ogmiosError
        errorHistory.insert(record, at: 0)
        if errorHistory.count > maxErrorHistory {
            errorHistory.removeLast()
        }
        
        // Update connection status
        updateConnectionStatus(from: ogmiosError)
        
        // Log error with context
        logError(record)
        
        // Send to monitoring service (if configured)
        reportToMonitoring(record)
    }
    
    private func updateConnectionStatus(from error: OgmiosError) {
        switch error {
        case .httpError(_), .websocketError(_):
            connectionStatus = .failed
        case .responseError(let message):
            if let code = error.errorCode, code == 2003 {
                // Acquired expired - connection is fine, just need to retry
                connectionStatus = .connected
            } else {
                connectionStatus = .connected // Server responded, connection is OK
            }
        case .timeoutError(_):
            connectionStatus = .reconnecting
        default:
            connectionStatus = .connected
        }
    }
    
    private func logError(_ record: ErrorRecord) {
        let timestamp = DateFormatter.iso8601.string(from: record.timestamp)
        print("[\(timestamp)] ERROR in \(record.operation): \(record.error.localizedDescription)")
        
        // Add additional context based on error type
        switch record.error {
        case .responseError(let message):
            if let code = record.error.errorCode {
                print("  Error code: \(code)")
                print("  Suggested action: \(suggestedAction(for: code))")
            }
        case .httpError(_), .websocketError(_):
            print("  Suggested action: Check network connection and server availability")
        case .timeoutError(_):
            print("  Suggested action: Consider increasing timeout or optimizing query")
        default:
            break
        }
    }
    
    private func suggestedAction(for errorCode: Int) -> String {
        switch errorCode {
        case 2001: return "Check current era and use compatible queries"
        case 2002: return "Query not available in current era"
        case 2003: return "Retry query to get fresh ledger snapshot"
        case 3005: return "Rebuild transaction for current era"
        case 3100, 3101: return "Check and fix transaction signatures"
        case 3122: return "Increase transaction fee"
        case 3123: return "Fix transaction input/output balance"
        default: return "Check Ogmios documentation for error code \(errorCode)"
        }
    }
    
    private func reportToMonitoring(_ record: ErrorRecord) {
        // Implement monitoring service integration
        // e.g., send to Sentry, DataDog, custom analytics
    }
    
    func clearErrorHistory() {
        errorHistory.removeAll()
        lastError = nil
    }
    
    func retry<T>(_ operation: @escaping () async throws -> T, operationName: String) async throws -> T {
        do {
            let result = try await withExponentialBackoff(operation: operation)
            
            // Success - update connection status if it was failing
            if connectionStatus == .failed || connectionStatus == .reconnecting {
                connectionStatus = .connected
            }
            
            return result
        } catch {
            handle(error, operation: operationName)
            throw error
        }
    }
}
```

## Error Handling in SwiftUI

```swift path=null start=null
import SwiftUI
import SwiftOgmios

struct CardanoDataView: View {
    @StateObject private var errorHandler = OgmiosErrorHandler()
    @StateObject private var dataService = CardanoDataService()
    
    @State private var currentEpoch: Int?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            // Connection status indicator
            HStack {
                Circle()
                    .fill(connectionStatusColor)
                    .frame(width: 12, height: 12)
                Text(connectionStatusText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Main content
            Group {
                if isLoading {
                    ProgressView("Loading...")
                } else if let epoch = currentEpoch {
                    VStack {
                        Text("Current Epoch")
                            .font(.headline)
                        Text("\(epoch)")
                            .font(.largeTitle)
                            .bold()
                    }
                } else {
                    Text("No data available")
                        .foregroundColor(.secondary)
                }
            }
            
            // Error display
            if let lastError = errorHandler.lastError {
                ErrorBannerView(error: lastError) {
                    Task { await loadData() }
                }
            }
            
            // Retry button
            Button("Refresh") {
                Task { await loadData() }
            }
            .disabled(isLoading)
        }
        .task {
            await loadData()
        }
        .environmentObject(errorHandler)
    }
    
    private var connectionStatusColor: Color {
        switch errorHandler.connectionStatus {
        case .connected: return .green
        case .reconnecting: return .yellow
        case .disconnected, .failed: return .red
        }
    }
    
    private var connectionStatusText: String {
        switch errorHandler.connectionStatus {
        case .connected: return "Connected"
        case .reconnecting: return "Reconnecting..."
        case .disconnected: return "Disconnected"
        case .failed: return "Connection Failed"
        }
    }
    
    @MainActor
    private func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            currentEpoch = try await errorHandler.retry({
                let response = try await dataService.client.ledgerStateQuery.epoch.execute()
                return response.result
            }, operationName: "fetch-current-epoch")
        } catch {
            // Error already handled by errorHandler.retry
            currentEpoch = nil
        }
    }
}

struct ErrorBannerView: View {
    let error: OgmiosError
    let onRetry: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Error")
                    .font(.headline)
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Retry", action: onRetry)
                .buttonStyle(.bordered)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}
```

## Logging and Diagnostics

### Structured Logging

```swift path=null start=null
import os.log

extension OgmiosClient {
    private static let logger = Logger(
        subsystem: "com.yourapp.ogmios",
        category: "client"
    )
    
    func logRequest(_ request: any JSONRPCRequest) {
        Self.logger.debug("Sending request: \(request.method) (ID: \(request.id?.description ?? "none"))")
    }
    
    func logResponse<T>(_ response: T) where T: JSONRPCResponse {
        Self.logger.debug("Received response: \(response.method) (ID: \(response.id?.description ?? "none"))")
    }
    
    func logError(_ error: OgmiosError, context: String) {
        Self.logger.error("Error in \(context): \(error.localizedDescription)")
        
        // Add error-specific details
        switch error {
        case .responseError(let message):
            if let code = error.errorCode {
                Self.logger.error("Error code: \(code)")
            }
        case .httpError(let message), .websocketError(let message):
            Self.logger.error("Transport error: \(message)")
        default:
            break
        }
    }
}
```

### Diagnostic Information Collection

```swift path=null start=null
struct DiagnosticInfo: Codable {
    let timestamp: Date
    let clientVersion: String
    let serverHealth: Health?
    let connectionType: String
    let lastError: String?
    let errorHistory: [ErrorSummary]
    
    struct ErrorSummary: Codable {
        let error: String
        let timestamp: Date
        let operation: String
    }
}

extension OgmiosErrorHandler {
    func generateDiagnosticInfo(client: OgmiosClient) async -> DiagnosticInfo {
        let serverHealth = try? await client.getServerHealth()
        
        let errorSummaries = errorHistory.map { record in
            DiagnosticInfo.ErrorSummary(
                error: record.error.localizedDescription,
                timestamp: record.timestamp,
                operation: record.operation
            )
        }
        
        return DiagnosticInfo(
            timestamp: Date(),
            clientVersion: "1.0.0", // Your app version
            serverHealth: serverHealth,
            connectionType: client.isWebSocketTransport ? "WebSocket" : "HTTP",
            lastError: lastError?.localizedDescription,
            errorHistory: errorSummaries
        )
    }
    
    func exportDiagnostics(client: OgmiosClient) async -> URL {
        let diagnostics = await generateDiagnosticInfo(client: client)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(diagnostics)
        
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("ogmios-diagnostics-\(Date().timeIntervalSince1970)")
            .appendingPathExtension("json")
        
        try! data.write(to: url)
        return url
    }
}
```

## Testing Error Scenarios

```swift path=null start=null
import XCTest
@testable import SwiftOgmios

class ErrorHandlingTests: XCTestCase {
    func testHTTPErrorHandling() async throws {
        let mockConnection = MockHTTPConnection()
        mockConnection.shouldFail = true
        mockConnection.errorMessage = "Connection refused"
        
        let client = try await OgmiosClient(
            httpOnly: true,
            httpConnection: mockConnection
        )
        
        do {
            _ = try await client.ledgerStateQuery.epoch.execute()
            XCTFail("Expected error")
        } catch OgmiosError.httpError(let message) {
            XCTAssertTrue(message.contains("Connection refused"))
        }
    }
    
    func testRetryLogic() async throws {
        let errorHandler = OgmiosErrorHandler()
        var attemptCount = 0
        
        do {
            _ = try await errorHandler.retry({
                attemptCount += 1
                if attemptCount < 3 {
                    throw OgmiosError.httpError("Temporary failure")
                }
                return "Success"
            }, operationName: "test-operation")
        } catch {
            XCTFail("Should have succeeded after retry")
        }
        
        XCTAssertEqual(attemptCount, 3)
    }
    
    func testCircuitBreakerPattern() async throws {
        let circuitBreaker = CircuitBreaker()
        
        // Fail repeatedly to open circuit
        for _ in 1...6 {
            do {
                _ = try await circuitBreaker.execute {
                    throw OgmiosError.responseError("Server error")
                }
            } catch {
                // Expected
            }
        }
        
        // Circuit should now be open
        do {
            _ = try await circuitBreaker.execute {
                return "Should not execute"
            }
            XCTFail("Circuit should be open")
        } catch OgmiosError.responseError(let message) {
            XCTAssertTrue(message.contains("Circuit breaker is open"))
        }
    }
}
```

## Best Practices Summary

1. **Always Handle Specific Error Types**: Don't use generic catch-all blocks
2. **Implement Retry Logic**: Use exponential backoff for transient failures
3. **Monitor Connection State**: Track and display connection status to users
4. **Log Structured Information**: Include context and error codes in logs
5. **Use Circuit Breakers**: Prevent cascading failures in distributed systems
6. **Provide User Feedback**: Show meaningful error messages and recovery options
7. **Test Error Scenarios**: Write tests for different failure modes
8. **Collect Diagnostics**: Gather information to help debug issues in production

## See Also

- <doc:GettingStarted> - Basic setup and first queries
- <doc:TransportTypes> - Transport-specific error handling
- <doc:AdvancedUsage> - Advanced error handling patterns
- <doc:LedgerStateQueries> - Query-specific error scenarios