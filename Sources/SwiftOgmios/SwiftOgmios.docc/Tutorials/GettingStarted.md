# Getting Started with SwiftOgmios

Learn how to install and configure SwiftOgmios, then make your first connection to an Ogmios server.

## Overview

This tutorial will guide you through setting up SwiftOgmios in your project and making your first query to an Ogmios server. By the end, you'll have a working connection and understand the basics of querying Cardano blockchain data.

## Prerequisites

Before you begin, you'll need:

1. **Ogmios Server**: A running Ogmios server connected to a Cardano node
2. **Xcode 16.0+** with Swift 6.1 support
3. **Target Platform**: iOS 14.0+, macOS 15.0+, watchOS 7.0+, or tvOS 14.0+

### Setting up Ogmios Server

If you don't have an Ogmios server running, you can start one using Docker:

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

For production use or testnet/mainnet, refer to the [official Ogmios documentation](https://ogmios.dev) for detailed setup instructions.

## Step 1: Installation

Add SwiftOgmios to your project using Swift Package Manager.

### Using Xcode

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies**
3. Enter the repository URL: `https://github.com/Kingpin-Apps/swift-ogmios.git`
4. Choose the version (latest stable is recommended)
5. Add SwiftOgmios to your target

### Using Package.swift

Add SwiftOgmios as a dependency in your `Package.swift`:

```swift path=null start=null
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "MyCardanoApp",
    platforms: [
        .iOS(.v14),
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/Kingpin-Apps/swift-ogmios.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyCardanoApp",
            dependencies: [
                .product(name: "SwiftOgmios", package: "swift-ogmios")
            ]
        )
    ]
)
```

## Step 2: Import and Basic Setup

Create a new Swift file and import SwiftOgmios:

```swift path=null start=null
import SwiftOgmios
import Foundation
```

## Step 3: Create Your First Client

SwiftOgmios supports both HTTP and WebSocket transports. For simple queries, HTTP is often sufficient and easier to manage:

```swift path=null start=null
import SwiftOgmios

@main
struct HelloOgmios {
    static func main() async throws {
        // Create an HTTP client (recommended for simple queries)
        let client = try await OgmiosClient(
            host: "localhost",    // Your Ogmios server host
            port: 1337,          // Your Ogmios server port
            secure: false,       // Use HTTP (set to true for HTTPS)
            httpOnly: true       // Use HTTP transport
        )
        
        print("✅ Connected to Ogmios server!")
        
        // Your queries will go here...
    }
}
```

For real-time applications that need continuous data streaming, use WebSocket transport:

```swift path=null start=null
// Create a WebSocket client (recommended for real-time applications)
let client = try await OgmiosClient(
    host: "localhost",
    port: 1337,
    secure: false,       // Use WS (set to true for WSS)
    httpOnly: false      // Use WebSocket transport
)
```

## Step 4: Make Your First Query

Let's query the current network tip to get basic information about the latest block:

```swift path=null start=null
@main
struct HelloOgmios {
    static func main() async throws {
        let client = try await OgmiosClient(httpOnly: true)
        
        do {
            // Query the current network tip
            let tip = try await client.ledgerStateQuery.tip.result()
            
            print("🎉 Success! Current blockchain tip:")
            print("   Slot: \(tip.slot)")
            print("   Block Hash: \(tip.id)")
            print("   Height: \(tip.height)")
            
        } catch {
            print("❌ Error querying tip: \(error)")
        }
    }
}
```

Expected output:
```
✅ Connected to Ogmios server!
🎉 Success! Current blockchain tip:
   Slot: 90908555
   Block Hash: 9ec5a59cde0ecf03d08b092be24a3347eae125276f2c39af282a32135b35b897
   Height: 3595887
```

## Step 5: Query Additional Information

Now let's expand our example to query more information about the current state:

```swift path=null start=null
@main
struct HelloOgmios {
    static func main() async throws {
        let client = try await OgmiosClient(httpOnly: true)
        
        do {
            // Query current epoch
            let epoch = try await client.ledgerStateQuery.epoch.result()
            print("📅 Current epoch: \(epoch)")
            
            // Query era summaries to understand blockchain eras
            let eraSummaries = try await client.ledgerStateQuery.eraSummaries.result()
            print("🗋  Available eras:")
            for era in eraSummaries {
                let endEpoch = era.end?.epoch ?? "current"
                print("   \(era.start.epoch) - \(endEpoch)")
            }
            
            // Check server health
            let health = try await client.getServerHealth()
            print("🏥 Server status: \(health.connectionStatus)")
            print("   Network: \(health.network)")
            print("   Version: \(health.version)")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
}
```

## Step 6: Error Handling Best Practices

Always implement proper error handling when working with network operations:

```swift path=null start=null
func queryTipWithErrorHandling() async throws {
    let client = try await OgmiosClient(httpOnly: true)
    
    do {
        // Using .result() for cleaner code (recommended)
        let tip = try await client.ledgerStateQuery.tip.result(
            id: .generateNextNanoId() // Optional: provide custom request ID
        )
        print("Tip received: \(tip)")
        
    } catch OgmiosError.httpError(let message) {
        print("HTTP connection error: \(message)")
        // Handle connection issues (retry, user notification, etc.)
        
    } catch OgmiosError.responseError(let message) {
        print("Ogmios server error: \(message)")
        // Handle server-side errors
        
    } catch OgmiosError.invalidResponse(let message) {
        print("Invalid response format: \(message)")
        // Handle malformed responses
        
    } catch {
        print("Unexpected error: \(error)")
        // Handle any other errors
    }
}
```

## Platform-Specific Considerations

### iOS Applications

For iOS apps, consider using SwiftOgmios in a background task or with proper lifecycle management:

```swift path=null start=null
import SwiftUI
import SwiftOgmios

@MainActor
class CardanoDataService: ObservableObject {
    @Published var currentEpoch: Int?
    @Published var isLoading = false
    
    private var client: OgmiosClient?
    
    func connect() async {
        isLoading = true
        do {
            client = try await OgmiosClient(
                host: "your-server.com",
                port: 1337,
                secure: true,  // Use HTTPS for production
                httpOnly: true
            )
            await fetchCurrentEpoch()
        } catch {
            print("Failed to connect: \(error)")
        }
        isLoading = false
    }
    
    private func fetchCurrentEpoch() async {
        guard let client = client else { return }
        
        do {
            let epoch = try await client.ledgerStateQuery.epoch.result()
            currentEpoch = epoch
        } catch {
            print("Failed to fetch epoch: \(error)")
        }
    }
}
```

### macOS Applications

For macOS apps, you have more flexibility with background processing:

```swift path=null start=null
import AppKit
import SwiftOgmios

class CardanoWindowController: NSWindowController {
    private var client: OgmiosClient?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        Task {
            await setupOgmiosConnection()
        }
    }
    
    private func setupOgmiosConnection() async {
        do {
            client = try await OgmiosClient(httpOnly: true)
            // Start background monitoring
            await startMonitoring()
        } catch {
            print("Connection failed: \(error)")
        }
    }
    
    private func startMonitoring() async {
        // Implement your monitoring logic here
    }
}
```

## Next Steps

Now that you have SwiftOgmios set up and working, explore these areas:

- **<doc:LedgerStateQueries>**: Learn about all available ledger queries
- **<doc:ErrorHandling>**: Implement robust error handling strategies
- **<doc:TransportTypes>**: Understand when to use HTTP vs WebSocket
- **<doc:ChainSynchronization>**: Set up real-time blockchain monitoring

## Troubleshooting

### Common Issues

**Connection Refused**: 
- Verify your Ogmios server is running
- Check the host and port configuration
- Ensure firewall settings allow the connection

**Invalid Response**: 
- Confirm your Ogmios server version is compatible
- Check that the Cardano node is fully synced

**Timeout Errors**:
- Increase timeout values for slow networks
- Consider using WebSocket for better connection management

### Getting Help

- Check the [Ogmios documentation](https://ogmios.dev) for server-side issues
- Review the SwiftOgmios [GitHub repository](https://github.com/Kingpin-Apps/swift-ogmios) for examples
- Join the Cardano developer community for support

You're now ready to start building Cardano applications with SwiftOgmios! 🚀
