# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

SwiftOgmios is a Swift JSON-RPC client library designed to communicate with Ogmios servers. Ogmios is a lightweight bridge interface for Cardano nodes that provides a JSON-RPC interface. This library provides both HTTP/HTTPS and WebSocket transport mechanisms with full async/await support.

## Development Commands

### Build and Test
```bash
# Build the project
swift build

# Run all tests
swift test

# Build for specific platform (if needed)
swift build --arch arm64

# Clean build artifacts
rm -rf .build/
```

### Development Workflow
```bash
# Generate Xcode project (for IDE development)
swift package generate-xcodeproj

# Open in Xcode
open SwiftOgmios.xcodeproj

# Run specific test
swift test --filter <test_name>
```

## Architecture Overview

### Core Components

1. **JSONRPCClient**: The main client class that handles communication with JSON-RPC servers. Supports both HTTP/HTTPS and WebSocket transports with async/await patterns.

2. **Transport Layer**: 
   - `JSONRPCTransport` enum defines connection types (http, https, websocket)
   - Protocol-based delegate pattern for transport events
   - Thread-safe request/response handling using concurrent dispatch queues

3. **Protocol Structures**:
   - `JSONRPCRequest`: Represents JSON-RPC 2.0 requests with flexible parameter support
   - `JSONRPCResponse<T>`: Generic response wrapper with error handling
   - `JSONRPCError`: Standard JSON-RPC error codes and custom error support
   - `JSONRPCId`: Flexible ID type (string, number, or null)
   - `JSONRPCParams`: Parameters can be arrays or objects
   - `AnyCodable`: Helper for encoding/decoding arbitrary JSON values

### Key Architecture Patterns

- **Async/Await**: All network operations use Swift's modern async/await concurrency
- **Generic Response Handling**: Type-safe response decoding using generics
- **Thread Safety**: Concurrent queue with barrier flags for safe state management
- **Transport Abstraction**: Protocol-based design allows easy transport switching

### Dependencies

- **SwiftCardanoCore**: Core Cardano blockchain utilities (v0.1.32+)
- **PotentCodables**: Enhanced JSON encoding/decoding capabilities (v3.6.0+)

## Development Notes

### Current Issues
- No known compilation issues - all warnings have been resolved

### Code Quality Considerations
- OgmiosClient now conforms to Sendable protocol for proper concurrency safety
- Uses @unchecked Sendable with manual thread safety via concurrent dispatch queues
- Consider using actors instead of dispatch queues for future improvements
- WebSocket implementation uses URLSessionWebSocketTask with custom SimpleWebSocketConnection wrapper
- Uses CheckedContinuation for async request/response handling

### Platform Support
- iOS 14.0+
- macOS 14.0+
- watchOS 7.0+
- tvOS 14.0+
- Swift 6.1+ required

## Testing Strategy

- Tests are located in `Tests/SwiftOgmiosTests/`
- Currently uses Swift Testing framework
- Test target depends on main SwiftOgmios module
- Tests are minimal and need expansion for comprehensive coverage

## Related Codebases

This package is part of the Kingpin-Apps Cardano ecosystem:
- `swift-cardano-core`: Core Cardano utilities and types
- `swift-cardano-chain`: Chain interaction utilities  
- `swift-cardano-txbuilder`: Transaction building tools
- `swift-blockfrost-api`: Blockfrost API client

When making changes, consider compatibility with these related packages.
