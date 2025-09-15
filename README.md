# SwiftOgmios

[![Swift 6.1](https://img.shields.io/badge/Swift-6.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS 14+](https://img.shields.io/badge/iOS-14+-blue.svg?style=flat)](https://developer.apple.com/ios/)
[![macOS 15+](https://img.shields.io/badge/macOS-15+-blue.svg?style=flat)](https://developer.apple.com/macos/)
[![Production Ready](https://img.shields.io/badge/Status-Production%20Ready-green.svg?style=flat)](#)
[![API Coverage](https://img.shields.io/badge/API%20Coverage-100%25-brightgreen.svg?style=flat)](#api-coverage)

A **production-ready** Swift client library for [Ogmios](https://ogmios.dev), providing **complete coverage** of all Ogmios protocols. SwiftOgmios offers both HTTP/HTTPS and WebSocket transport mechanisms with full async/await support and comprehensive documentation.

## About Ogmios

[Ogmios](https://ogmios.dev) offers a JSON-RPC interface to interact with a Cardano node. SwiftOgmios provides **complete coverage** of all Ogmios protocols:

- **Ledger State Queries** (17 queries): Current ledger state, stake distribution, protocol parameters, UTxO sets, governance data, etc.
- **Network Queries** (4 queries): Block height, network tip, genesis configuration, start time
- **Chain Synchronization** (2 operations): Follow the Cardano blockchain in real-time with intersection finding and block streaming
- **Transaction Submission** (2 operations): Submit transactions to the network and evaluate execution
- **Mempool Monitoring** (5 operations + helpers): Monitor transaction mempool changes, acquire snapshots, check transaction status

## Features

- ✅ **Modern Swift Concurrency**: Full async/await support
- ✅ **Multiple Transport Types**: HTTP/HTTPS and WebSocket connections
- ✅ **Type Safety**: Strongly typed responses using Swift's type system
- ✅ **JSON-RPC 2.0 Compliant**: Full compliance with JSON-RPC 2.0 specification  
- ✅ **Thread Safe**: Concurrent operations using dispatch queues
- ✅ **Comprehensive Error Handling**: Detailed error responses from Ogmios
- ✅ **Sendable Compliance**: Safe for concurrent environments
- ✅ **Complete Protocol Coverage**: All Ogmios protocols fully implemented
- ✅ **Production Ready**: Comprehensive documentation and examples

## Requirements

- iOS 14.0+ / macOS 15.0+ / watchOS 7.0+ / tvOS 14.0+
- Swift 6.1+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add SwiftOgmios to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Kingpin-Apps/swift-ogmios.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. Go to File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/Kingpin-Apps/swift-ogmios.git`
3. Choose the version and add to your target

## API Coverage

SwiftOgmios provides **100% coverage** of the Ogmios JSON-RPC API with **30 total operations** across all protocols:

| Protocol | Operations | Coverage |
|----------|------------|----------|
| **Ledger State Queries** | 17 operations | ✅ 100% Complete |
| **Network Queries** | 4 operations | ✅ 100% Complete |
| **Chain Synchronization** | 2 operations | ✅ 100% Complete |
| **Transaction Submission** | 2 operations | ✅ 100% Complete |
| **Mempool Monitoring** | 5 operations + 2 helpers | ✅ 100% Complete |
| **Server Health** | 1 endpoint | ✅ 100% Complete |


## API Methods: .execute() vs .result()

SwiftOgmios provides two methods for each operation, giving you flexibility in how you handle responses:

### Using `.result()` - Recommended for Most Cases

The `.result()` method returns just the data you need, making your code cleaner and more focused:

```swift
// Returns just the epoch number (e.g., 220)
let currentEpoch: Epoch = try await client.ledgerStateQuery.epoch.result()
print("Current epoch: \(currentEpoch)")

// Returns just the tip information
let tip: LedgerStateTip = try await client.ledgerStateQuery.tip.result()
print("Current slot: \(tip.slot)")
```

### Using `.execute()` - For Advanced Use Cases

The `.execute()` method returns the complete JSON-RPC response, useful when you need metadata:

```swift
// Returns the full JSON-RPC response with metadata
let response = try await client.ledgerStateQuery.epoch.execute(id: .string("my-id"))
print("Epoch: \(response.result), Request ID: \(response.id!)")
print("Method: \(response.method), JSON-RPC: \(response.jsonrpc)")
```

### When to Use Each Method

| Use `.result()` when: | Use `.execute()` when: |
|-----------------------|------------------------|
| You only need the actual data | You need request/response correlation |
| Writing simple, clean code | Implementing custom logging |
| Building typical applications | Debugging JSON-RPC communication |
| Following best practices | Handling request IDs manually |
| **Examples:** Wallet apps, DApps, data analysis | **Examples:** Testing tools, monitoring systems |

**💡 Tip**: Most applications should use `.result()` for cleaner, more readable code.

### Practical Comparison

```swift
// ✅ Preferred: Clean and focused
let epoch = try await client.ledgerStateQuery.epoch.result()
let tip = try await client.ledgerStateQuery.tip.result()
print("Epoch \(epoch) at slot \(tip.slot)")

// 🔧 Advanced: When you need metadata
let epochResponse = try await client.ledgerStateQuery.epoch.execute()
let tipResponse = try await client.ledgerStateQuery.tip.execute()
print("Request \(epochResponse.id!) returned epoch \(epochResponse.result)")
print("Request \(tipResponse.id!) returned tip at slot \(tipResponse.result.slot)")
```

## Quick Start

### Prerequisites

First, you'll need a running Ogmios server. The easiest way is a cloud-based environment on (demeter.run)[https://demeter.run] Or install cardano-node and Ogmios server as described [here](https://ogmios.dev/getting-started/). (Docker installation is recommended.) You can start one using the Docker or by building from source. Here's an example using Docker Compose:

```bash
services:
  cardano-node:
    container_name: cardano-node
    image: ghcr.io/intersectmbo/cardano-node:${CARDANO_NODE_VERSION:-latest}
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -f 127.0.0.1:12788 || exit 1"]
      interval: 60s
      timeout: 10s
      retries: 5
    environment:
      - NETWORK=${NETWORK:-preview}
    ports:
      - "3001:3001"
    volumes:
      - node-db:/data/db
      - node-ipc:/ipc
      - node-config:/opt/cardano/config

  ogmios:
    container_name: ogmios
    image: cardanosolutions/ogmios:${OGMIOS_VERSION:-latest}
    restart: on-failure
    environment:
      - NETWORK=${NETWORK:-preview}
    command:
      [
        "--host",
        "0.0.0.0",
        "--node-socket",
        "/socket/node.socket",
        "--node-config",
        "/opt/cardano/config/${NETWORK:-preview}/cardano-node/config.json",
      ]
    volumes:
      - node-config:/opt/cardano/config:ro
      - node-ipc:/socket
    ports:
      - ${OGMIOS_PORT:-1337}:1337
    depends_on:
      cardano-node:
        condition: service_healthy

volumes:
  node-db:
  node-ipc:
  node-config:

```

### Basic Usage

SwiftOgmios provides **5 protocol namespaces** with **30 operations** for complete Ogmios coverage:

```swift
import SwiftOgmios

// Create HTTP client (recommended for simple queries)
let httpClient = try await OgmiosClient(httpOnly: true)

// Or create WebSocket client (required for streaming protocols)
let wsClient = try await OgmiosClient(httpOnly: false)

// 📋 Ledger State Queries (17 operations)
let epoch = try await httpClient.ledgerStateQuery.epoch.result()
let tip = try await httpClient.ledgerStateQuery.tip.result()
let stakeDistribution = try await httpClient.ledgerStateQuery.liveStakeDistribution.result()
let utxos = try await httpClient.ledgerStateQuery.utxo.result(addresses: addresses)

// 🌐 Network Queries (4 operations)
let networkTip = try await httpClient.networkQuery.tip.result()
let blockHeight = try await httpClient.networkQuery.blockHeight.result()

// 🔄 Chain Synchronization (2 operations, WebSocket required)
let intersection = try await wsClient.chainSync.findIntersection.result(points: points)
let nextBlock = try await wsClient.chainSync.nextBlock.result()

// 📤 Transaction Submission (2 operations)
let submitResult = try await httpClient.transactionSubmission.submitTransaction.result(transaction: txBytes)
let evalResult = try await httpClient.transactionSubmission.evaluateTransaction.result(transaction: txBytes)

// 🕰️ Mempool Monitoring (5 operations + helpers, WebSocket required)
let allTransactions = try await wsClient.mempoolMonitor.getMempoolTransactions()  // Convenience helper
try await wsClient.mempoolMonitor.waitForEmptyMempool(timeoutSeconds: 30.0)  // Convenience helper
```

### Custom Connection Parameters

```swift
// Connect to custom Ogmios instance
let client = try await OgmiosClient(
    host: "your-ogmios-server.com",
    port: 1337,
    secure: true  // Use HTTPS/WSS
)

// Most queries using .result() (recommended)
let epoch = try await client.ledgerStateQuery.epoch.result()
print("Current epoch: \(epoch)")

// When you need to track request IDs, use .execute()
let epochResponse = try await client.ledgerStateQuery.epoch.execute(
    id: .string("my-custom-id")
)
print("Epoch: \(epochResponse.result), ID: \(epochResponse.id!)")
```

## Available Queries

### Available Protocols and Queries

#### Ledger State Queries

| Query | Description | Status |
|-------|-------------|--------|
| `constitution` | Current constitution definition (Conway era) | ✅ |
| `constitutionalCommittee` | Constitutional committee state (Conway era) | ✅ |
| `delegateRepresentatives` | Registered delegate representatives | ✅ |
| `dump` | Complete ledger state dump | ✅ |
| `epoch` | Current epoch number | ✅ |
| `eraStart` | Start of current era | ✅ |
| `eraSummaries` | Era boundaries and parameters | ✅ |
| `governanceProposals` | Active governance proposals | ✅ |
| `liveStakeDistribution` | Current stake distribution across pools | ✅ |
| `nonces` | Consensus nonces for randomness | ✅ |
| `operationalCertificates` | Pool operational certificate counters | ✅ |
| `projectedRewards` | Projected rewards for stake pools | ✅ |
| `protocolParameters` | Current protocol parameters | ✅ |
| `proposedProtocolParameters` | Proposed protocol parameter updates | ✅ |
| `rewardAccountSummaries` | Stake account summaries and rewards | ✅ |
| `rewardsProvenance` | Rewards provenance (deprecated, use stakePoolsPerformances) | ✅ |
| `stakePools` | Stake pool information | ✅ |
| `stakePoolsPerformances` | Pool performance metrics | ✅ |
| `tip` | Current ledger tip | ✅ |
| `treasuryAndReserves` | Treasury and reserves Ada amounts | ✅ |
| `utxo` | UTxO set (by addresses, output references, or whole set) | ✅ |

#### Network Queries

| Query | Description | Status |
|-------|-------------|--------|
| `blockHeight` | Network's highest block number | ✅ |
| `genesisConfiguration` | Genesis configuration for specific era | ✅ |
| `startTime` | Network start time | ✅ |
| `tip` | Network tip information | ✅ |

#### Chain Synchronization

| Method | Description | Status |
|--------|-------------|--------|
| `findIntersection` | Find intersection point for chain sync | ✅ |
| `nextBlock` | Get next block in chain synchronization | ✅ |

#### Transaction Submission

| Method | Description | Status |
|--------|-------------|--------|
| `submitTransaction` | Submit transaction to network | ✅ |
| `evaluateTransaction` | Evaluate transaction execution | ✅ |

#### Mempool Monitoring

| Method | Description | Status |
|--------|-------------|--------|
| `acquireMempool` | Acquire mempool snapshot | ✅ |
| `hasTransaction` | Check if transaction exists in mempool | ✅ |
| `nextTransaction` | Get next transaction from mempool | ✅ |
| `releaseMempool` | Release mempool snapshot | ✅ |
| `sizeOfMempool` | Get mempool size information | ✅ |
| Helper: `getMempoolTransactions()` | Get all mempool transactions | ✅ |
| Helper: `waitForEmptyMempool()` | Wait for mempool to be empty | ✅ |

### Usage Examples

#### Ledger State Queries

```swift
// Query current epoch
let currentEpoch = try await client.ledgerStateQuery.epoch.result()
print("Current epoch: \(currentEpoch)")

// Query era summaries
let eraSummaries = try await client.ledgerStateQuery.eraSummaries.result()
for eraSummary in eraSummaries {
    print("Era: \(eraSummary.start.epoch) - \(eraSummary.end?.epoch ?? "current")")
}

// Query UTxO set by addresses
let addresses = [Address("addr_test1qz66ue36465w2qq40005h2hadad6pnjht8mu6sgplsfj74qdjnshguewlx4ww0eet26y2pal4xpav5prcydf28cvxtjqx46x7f")]
let utxos = try await client.ledgerStateQuery.utxo.result(
    addresses: addresses,
    id: .generateNextNanoId()
)
print("Found \(utxos.count) UTxOs")

// Query protocol parameters
let protocolParams = try await client.ledgerStateQuery.protocolParameters.result()
print("Min fee A: \(protocolParams.minFeeCoefficient)")
```

#### Network Queries

```swift
// Query network tip
let networkTip = try await client.networkQuery.tip.result()
print("Network tip slot: \(networkTip.slot)")

// Query block height
let blockHeight = try await client.networkQuery.blockHeight.result()
print("Block height: \(blockHeight)")

// Query genesis configuration
let genesis = try await client.networkQuery.genesisConfiguration.result(
    era: "shelley",
    id: .generateNextNanoId()
)
print("Network: \(genesis.networkId)")
```

#### Chain Synchronization

```swift
// Find intersection and start syncing
let points = [Point(slot: 123456, id: "abc123...")]
let intersection = try await client.chainSync.findIntersection.result(
    points: points,
    id: .generateNextNanoId()
)
print("Found intersection at slot: \(intersection.tip.slot)")

// Get next block
let nextBlock = try await client.chainSync.nextBlock.result()
if case .block(let block) = nextBlock.block {
    print("Received block: \(block.header.blockHeight)")
}
```

#### Transaction Submission

```swift
// Submit a transaction (transaction building not shown)
let txBytes = Data(/* your transaction CBOR bytes */)
let submitResult = try await client.transactionSubmission.submitTransaction.result(
    transaction: txBytes,
    id: .generateNextNanoId()
)
print("Transaction submitted: \(submitResult.transaction.id)")

// Evaluate transaction
let evalResult = try await client.transactionSubmission.evaluateTransaction.result(
    transaction: txBytes,
    additionalUtxo: [:],
    id: .generateNextNanoId()
)
print("Execution units: \(evalResult.executionUnits)")
```

#### Mempool Monitoring

```swift
// Get all mempool transactions (helper method)
let mempoolTxs = try await client.mempoolMonitor.getMempoolTransactions()
print("Mempool contains \(mempoolTxs.count) transactions")

// Check if specific transaction is in mempool
let txId = "abc123..."
let hasTransaction = try await client.mempoolMonitor.hasTransaction.result(
    transaction: TransactionId(txId),
    id: .generateNextNanoId()
)
print("Transaction in mempool: \(hasTransaction)")

// Wait for empty mempool (helper method)
try await client.mempoolMonitor.waitForEmptyMempool(timeoutSeconds: 30.0)
print("Mempool is now empty")
```

## Error Handling

SwiftOgmios provides comprehensive error handling for various scenarios:

### Basic Error Handling

```swift
do {
    let epoch = try await client.ledgerStateQuery.epoch.result()
    print("Success: \(epoch)")
} catch OgmiosError.httpError(let message) {
    print("HTTP Error: \(message)")
} catch OgmiosError.websocketError(let message) {
    print("WebSocket Error: \(message)")
} catch OgmiosError.responseError(let message) {
    print("Ogmios Response Error: \(message)")
} catch OgmiosError.invalidResponse(let message) {
    print("Invalid Response: \(message)")
} catch OgmiosError.timeoutError(let message) {
    print("Timeout Error: \(message)")
} catch {
    print("Unknown error: \(error)")
}
```

### Error Handling with Retry Logic

```swift
func queryWithRetry<T>(maxRetries: Int = 3, delay: TimeInterval = 1.0, operation: @escaping () async throws -> T) async throws -> T {
    var lastError: Error?
    
    for attempt in 1...maxRetries {
        do {
            return try await operation()
        } catch OgmiosError.httpError(let message) where attempt < maxRetries {
            print("HTTP error on attempt \(attempt): \(message). Retrying in \(delay) seconds...")
            lastError = OgmiosError.httpError(message)
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        } catch OgmiosError.websocketError(let message) where attempt < maxRetries {
            print("WebSocket error on attempt \(attempt): \(message). Retrying in \(delay) seconds...")
            lastError = OgmiosError.websocketError(message)
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        } catch {
            // Non-retryable error or final attempt
            throw error
        }
    }
    
    // Should never reach here, but throw the last error if we do
    throw lastError ?? OgmiosError.responseError("Max retries exceeded")
}

// Usage example
do {
    let epoch = try await queryWithRetry {
        return try await client.ledgerStateQuery.epoch.result()
    }
    print("Current epoch: \(epoch)")
} catch {
    print("Failed after retries: \(error)")
}
```

### Transaction Submission Error Mapping

SwiftOgmios provides detailed error mapping for transaction submission failures:

```swift
do {
    let result = try await client.transactionSubmission.submitTransaction.result(
        transaction: transactionBytes,
        id: .generateNextNanoId()
    )
    print("Transaction submitted successfully: \(result.transaction.id)")
} catch let error {
    // SwiftOgmios automatically maps Ogmios error codes to specific failure types
    switch error {
    case OgmiosError.responseError(let message):
        if message.contains("3005") {
            print("Era mismatch - transaction not valid in current era")
        } else if message.contains("3100") {
            print("Invalid signatures")
        } else if message.contains("3123") {
            print("Value not conserved - input/output mismatch")
        } else if message.contains("3122") {
            print("Transaction fee too small")
        } else {
            print("Transaction submission failed: \(message)")
        }
    default:
        print("Unexpected error: \(error)")
    }
}
```

## Server Health Check

Check if your Ogmios server is running and responsive:

```swift
do {
    let health = try await client.getServerHealth()
    print("Server Status: \(health.connectionStatus)")
    print("Current Era: \(health.currentEra)")
    print("Network: \(health.network)")
    print("Version: \(health.version)")
} catch {
    print("Server health check failed: \(error)")
}
```

## Transport Types

### HTTP/HTTPS Transport
Best for simple request-response patterns:

```swift
let httpClient = try await OgmiosClient(
    host: "localhost",
    port: 1337,
    secure: false,  // Use HTTP
    httpOnly: true
)
```

### WebSocket Transport
Best for real-time applications and chain following:

```swift
let wsClient = try await OgmiosClient(
    host: "localhost",
    port: 1337,
    secure: false,  // Use WS
    httpOnly: false
)
```


## Dependencies

- [SwiftCardanoCore](https://github.com/Kingpin-Apps/swift-cardano-core): Core Cardano types and utilities

> **Note**: SwiftOgmios uses SwiftCardanoCore's JSON codable types internally but this dependency is automatically managed by Swift Package Manager when you add SwiftOgmios to your project.

## Related Projects

This library is part of the Kingpin-Apps Cardano ecosystem:

- [swift-cardano-core](https://github.com/Kingpin-Apps/swift-cardano-core): Core Cardano utilities and types
- [swift-cardano-chain](https://github.com/Kingpin-Apps/swift-cardano-chain): Chain interaction utilities  
- [swift-cardano-txbuilder](https://github.com/Kingpin-Apps/swift-cardano-txbuilder): Transaction building tools
- [swift-blockfrost-api](https://github.com/Kingpin-Apps/swift-blockfrost-api): Blockfrost API client

## Contributing

Contributions are welcome! This project is **production-ready and feature-complete**, but we're always looking to improve. Areas where contributions are particularly valuable:

1. **Performance Optimization**: Connection pooling, caching strategies, and response processing improvements
2. **Testing**: Additional edge cases, stress testing, and integration test scenarios
3. **Examples & Tutorials**: Real-world usage examples, sample applications, and advanced patterns
4. **Developer Experience**: IDE integrations, debugging tools, and enhanced logging
5. **Platform Support**: Additional platform optimizations and deployment strategies

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Ogmios](https://ogmios.dev) team for creating an excellent Cardano bridge
- [Input Output Global](https://iog.io) for the Cardano blockchain
- The Swift community for excellent async/await and concurrency tools
