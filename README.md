# SwiftOgmios

[![Swift 6.1](https://img.shields.io/badge/Swift-6.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS 14+](https://img.shields.io/badge/iOS-14+-blue.svg?style=flat)](https://developer.apple.com/ios/)
[![macOS 14+](https://img.shields.io/badge/macOS-14+-blue.svg?style=flat)](https://developer.apple.com/macos/)

A modern Swift client library for [Ogmios](https://ogmios.dev), a lightweight bridge interface for Cardano nodes. SwiftOgmios provides both HTTP/HTTPS and WebSocket transport mechanisms with full async/await support.

## About Ogmios

[Ogmios](https://ogmios.dev) offers a JSON-RPC interface to interact with a Cardano node. It provides access to various Cardano protocols including:

- **Ledger State Queries**: Query current ledger state, stake distribution, protocol parameters, etc.
- **Chain Synchronization**: Follow the Cardano blockchain in real-time
- **Transaction Submission**: Submit transactions to the network
- **Mempool Monitoring**: Monitor transaction mempool changes

## Features

- ✅ **Modern Swift Concurrency**: Full async/await support
- ✅ **Multiple Transport Types**: HTTP/HTTPS and WebSocket connections
- ✅ **Type Safety**: Strongly typed responses using Swift's type system
- ✅ **JSON-RPC 2.0 Compliant**: Full compliance with JSON-RPC 2.0 specification  
- ✅ **Thread Safe**: Concurrent operations using dispatch queues
- ✅ **Comprehensive Error Handling**: Detailed error responses from Ogmios
- ✅ **Sendable Compliance**: Safe for concurrent environments
- 🚧 **Partial Implementation**: Currently supports ledger state queries (more protocols coming soon)

## Requirements

- iOS 14.0+ / macOS 14.0+ / watchOS 7.0+ / tvOS 14.0+
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

## Quick Start

### Prerequisites

First, you'll need a running Ogmios server. You can start one using Docker or by building from source. Here's an example using Docker:

```bash
# Start a Cardano node (replace with your node configuration)
docker run -d \
  --name cardano-node \
  -v /path/to/config:/config \
  -v /path/to/data:/data \
  inputoutput/cardano-node:latest \
  run --config /config/config.json \
      --database-path /data/db \
      --socket-path /data/node.socket

# Start Ogmios server
ogmios \
  --node-config /Users/hadderley/cardano/mainnet/config/config.json \
  --node-socket /Users/hadderley/cardano/mainnet/socket/node.socket \
  --host 127.0.0.1 \
  --port 1337
```

### Basic Usage

```swift
import SwiftOgmios

// Create HTTP client (recommended for simple queries)
let httpClient = try await OgmiosClient(httpOnly: true)

// Or create WebSocket client (recommended for real-time applications)
let wsClient = try await OgmiosClient(httpOnly: false)

// Query current epoch
let epoch = try await httpClient.ledgerStateQuery.epoch.execute()
print("Current epoch: \(epoch.result)")

// Query network tip
let tip = try await httpClient.ledgerStateQuery.tip.execute()
print("Current tip: \(tip.result)")

// Query live stake distribution
let stakeDistribution = try await httpClient.ledgerStateQuery.liveStakeDistribution.execute()
print("Found \(stakeDistribution.result.value.count) stake pools")
```

### Custom Connection Parameters

```swift
// Connect to custom Ogmios instance
let client = try await OgmiosClient(
    host: "your-ogmios-server.com",
    port: 1337,
    secure: true  // Use HTTPS/WSS
)

// Query with custom JSON-RPC ID
let epochResponse = try await client.ledgerStateQuery.epoch.execute(
    id: .string("my-custom-id")
)
print("Epoch: \(epochResponse.result), ID: \(epochResponse.id!)")
```

## Available Queries

### Currently Supported Ledger State Queries

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
| `tip` | Current ledger tip | ✅ |

### Usage Examples

```swift
// Query current epoch
let epochResponse = try await client.ledgerStateQuery.epoch.execute()
let currentEpoch = epochResponse.result
print("Current epoch: \(currentEpoch)")

// Query era summaries
let eraSummariesResponse = try await client.ledgerStateQuery.eraSummaries.execute()
for eraSummary in eraSummariesResponse.result {
    print("Era: \(eraSummary.start.epoch) - \(eraSummary.end?.epoch ?? "current")")
}

// Query governance proposals
let proposalsResponse = try await client.ledgerStateQuery.governanceProposals.execute()
for proposal in proposalsResponse.result {
    print("Proposal: \(proposal.proposal.transaction.id)")
}

// Query delegate representatives
let delegatesResponse = try await client.ledgerStateQuery.delegateRepresentatives.execute()
for delegate in delegatesResponse.result {
    print("Delegate: \(delegate.id), Type: \(delegate.type)")
}

// Query stake pool information
let stakeDistribution = try await client.ledgerStateQuery.liveStakeDistribution.execute()
for (poolId, poolInfo) in stakeDistribution.result.value {
    print("Pool \(poolId.value): \(poolInfo.stake) stake")
}
```

## Error Handling

SwiftOgmios provides comprehensive error handling for various scenarios:

```swift
do {
    let response = try await client.ledgerStateQuery.epoch.execute()
    print("Success: \(response.result)")
} catch OgmiosError.httpError(let message) {
    print("HTTP Error: \(message)")
} catch OgmiosError.websocketError(let message) {
    print("WebSocket Error: \(message)")
} catch OgmiosError.responseError(let message) {
    print("Ogmios Response Error: \(message)")
} catch OgmiosError.invalidResponse(let message) {
    print("Invalid Response: \(message)")
} catch {
    print("Unknown error: \(error)")
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

## Project Status

🚧 **This project is currently under active development**

### Completed
- ✅ Core JSON-RPC 2.0 client infrastructure
- ✅ HTTP/HTTPS and WebSocket transport layers
- ✅ Ledger state query protocol (partial)
- ✅ Type-safe response handling
- ✅ Comprehensive error handling
- ✅ Async/await concurrency support
- ✅ Thread safety with Sendable compliance

### In Progress
- 🔄 Additional ledger state queries
- 🔄 Chain synchronization protocol
- 🔄 Transaction submission protocol
- 🔄 Mempool monitoring protocol

### Planned
- 📋 Complete Ogmios protocol coverage
- 📋 Advanced connection management
- 📋 Retry mechanisms and connection pooling
- 📋 Comprehensive documentation
- 📋 Example applications

## Dependencies

- [SwiftCardanoCore](https://github.com/Kingpin-Apps/swift-cardano-core): Core Cardano types and utilities
- [PotentCodables](https://github.com/KINGH242/PotentCodables): Enhanced JSON encoding/decoding

## Related Projects

This library is part of the Kingpin-Apps Cardano ecosystem:

- [swift-cardano-core](https://github.com/Kingpin-Apps/swift-cardano-core): Core Cardano utilities and types
- [swift-cardano-chain](https://github.com/Kingpin-Apps/swift-cardano-chain): Chain interaction utilities  
- [swift-cardano-txbuilder](https://github.com/Kingpin-Apps/swift-cardano-txbuilder): Transaction building tools
- [swift-blockfrost-api](https://github.com/Kingpin-Apps/swift-blockfrost-api): Blockfrost API client

## Contributing

Contributions are welcome! This project is in active development, and we're building it out incrementally. Areas where help is particularly welcome:

1. **Additional Protocol Implementation**: Help implement remaining Ogmios protocols
2. **Testing**: Add more comprehensive tests and edge cases
3. **Documentation**: Improve code documentation and examples
4. **Performance**: Optimize connection handling and response processing

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Ogmios](https://ogmios.dev) team for creating an excellent Cardano bridge
- [Input Output Global](https://iog.io) for the Cardano blockchain
- The Swift community for excellent async/await and concurrency tools
