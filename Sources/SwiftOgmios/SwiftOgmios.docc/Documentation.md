# ``SwiftOgmios``

A modern Swift client library for Ogmios, providing JSON-RPC access to Cardano nodes with async/await support.

## Overview

SwiftOgmios is a comprehensive Swift client library that provides a type-safe, async/await-based interface to [Ogmios](https://ogmios.dev), a lightweight bridge interface for Cardano nodes. It supports all major Ogmios protocols including ledger state queries, chain synchronization, transaction submission, and mempool monitoring.

### Key Features

- **Modern Swift Concurrency**: Full async/await support with thread-safe operations
- **Multiple Transport Types**: HTTP/HTTPS and WebSocket connections with automatic failover
- **Type Safety**: Strongly typed responses using Swift's type system and generics
- **Comprehensive Protocol Support**: Complete coverage of Ogmios JSON-RPC protocols
- **Error Handling**: Detailed error responses with specific error code mapping
- **Mobile Optimized**: Designed for both iOS and macOS applications

### API Methods

SwiftOgmios provides two methods for each operation:

- **`.result()`** (recommended): Returns just the data you need for cleaner, more focused code
- **`.execute()`** (advanced): Returns the complete JSON-RPC response with metadata for debugging and logging

```swift
// Using .result() for cleaner code (recommended)
let epoch: Epoch = try await client.ledgerStateQuery.epoch.result()

// Using .execute() when you need response metadata
let response = try await client.ledgerStateQuery.epoch.execute()
print("Epoch: \(response.result), Request ID: \(response.id!)")
```

Most applications should use `.result()` for better readability and simpler error handling.

### Architecture Overview

SwiftOgmios follows a modular architecture that separates concerns between transport, protocol handling, and response processing:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   Application   │    │   SwiftOgmios    │    │   Ogmios Server     │
│                 │────│                  │────│                     │
│                 │    │ ┌──────────────┐ │    │                     │
│                 │    │ │OgmiosClient  │ │    │                     │
│                 │    │ │              │ │    │                     │
│                 │    │ └──────────────┘ │    │                     │
│                 │    │         │        │    │                     │
│                 │    │ ┌──────────────┐ │    │ ┌─────────────────┐ │
│                 │    │ │ Transport    │ │    │ │ Cardano Node    │ │
│                 │    │ │ HTTP/WS      │ │────│ │                 │ │
│                 │    │ └──────────────┘ │    │ └─────────────────┘ │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
```

### Platform Support

- **iOS**: 14.0+
- **macOS**: 15.0+
- **watchOS**: 7.0+
- **tvOS**: 14.0+
- **Swift**: 6.1+

## Getting Started

To get started with SwiftOgmios, begin with the getting started tutorial which covers installation and basic usage:

- <doc:GettingStarted>

## Tutorials

### Essential Guides

- <doc:GettingStarted> - Installation, setup, and your first query
- <doc:LedgerStateQueries> - Complete guide to all ledger state queries
- <doc:ErrorHandling> - Comprehensive error handling strategies

### Protocol-Specific Tutorials

- <doc:ChainSynchronization> - Real-time blockchain synchronization
- <doc:TransactionSubmission> - Submit and monitor transactions
- <doc:MempoolMonitoring> - Monitor mempool changes and transaction status
- <doc:TransportTypes> - HTTP vs WebSocket transports and optimization

### Advanced Topics

- <doc:AdvancedUsage> - Testing patterns, concurrency, and performance optimization

## Topics

### Core API

- ``OgmiosClient``
- ``JSONRPCTransport``

### Protocol Groups

- ``OgmiosClient/LedgerStateQuery``
- ``OgmiosClient/NetworkQuery``
- ``OgmiosClient/ChainSync``
- ``OgmiosClient/TransactionSubmission``
- ``OgmiosClient/MempoolMonitor``

### Transport & Connection

- ``JSONRPCTransportDelegate``
- ``HTTPConnectable``
- ``WebSocketConnectable``

### Error Handling

- ``OgmiosError``
- ``JSONRPCError``
- ``JSONRPCResponseError``

### JSON-RPC Protocol Types

- ``JSONRPCRequest``
- ``JSONRPCResponse``
- ``JSONRPCId``
- ``JSONRPCParams``

## Related Documentation

- [Ogmios Documentation](https://ogmios.dev) - Official Ogmios server documentation
- [SwiftCardanoCore](https://github.com/Kingpin-Apps/swift-cardano-core) - Core Cardano types and utilities
- [Cardano Developer Resources](https://developers.cardano.org) - General Cardano development guides
