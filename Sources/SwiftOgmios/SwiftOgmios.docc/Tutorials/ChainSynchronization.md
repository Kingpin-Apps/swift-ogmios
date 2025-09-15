# Chain Synchronization

Learn how to synchronize with the Cardano blockchain in real-time using the Chain Sync protocol.

## Overview

Chain synchronization allows you to follow the Cardano blockchain in real-time, receiving new blocks as they are produced. SwiftOgmios provides a powerful Chain Sync protocol implementation that handles rollbacks, forks, and provides efficient streaming of blockchain data.

This tutorial covers setting up chain synchronization, handling blocks and rollbacks, and building robust real-time blockchain applications.

## Chain Sync Fundamentals

The Chain Sync protocol follows a simple pattern:

1. **Find Intersection**: Establish a common point with the server
2. **Request Next Block**: Stream blocks from the intersection point
3. **Handle Rollbacks**: Deal with chain reorganizations
4. **Process Blocks**: Extract and store relevant data

### Basic Chain Sync Pattern

```swift path=null start=null
import SwiftOgmios

// Create WebSocket client (required for chain sync)
let client = try await OgmiosClient(httpOnly: false)

// Find intersection with tip
let intersectionResponse = try await client.chainSync.findIntersection.execute(
    points: [/* your known points */],
    id: .generateNextNanoId()
)

// Start requesting blocks
while true {
    let blockResponse = try await client.chainSync.nextBlock.execute(
        id: .generateNextNanoId()
    )
    
    switch blockResponse.result.direction {
    case .forward:
        // Process new block
        if case .block(let block) = blockResponse.result.block {
            print("Received block: \(block.header.blockHeight)")
        }
    case .backward:
        // Handle rollback
        print("Rollback to point: \(blockResponse.result.block)")
    }
}
```

## Finding Intersection Points

Before synchronizing, you need to find a common intersection point with the Ogmios server.

### Starting from Genesis

```swift path=null start=null
// Start from the very beginning of the blockchain
let genesisIntersection = try await client.chainSync.findIntersection.execute(
    points: [], // Empty array means start from genesis
    id: .generateNextNanoId()
)

print("Intersection found: \(genesisIntersection.result)")
```

### Starting from Known Points

```swift path=null start=null
// Start from known block points (more efficient)
let knownPoints = [
    Point(slot: 95654321, id: "abc123..."),
    Point(slot: 95654300, id: "def456..."),
    Point(slot: 95654250, id: "ghi789...")
]

let intersection = try await client.chainSync.findIntersection.execute(
    points: knownPoints,
    id: .generateNextNanoId()
)

switch intersection.result {
case .intersectionFound(let point):
    print("Found intersection at: \(point)")
case .intersectionNotFound:
    print("No intersection found with provided points")
    // Fall back to genesis or handle error
}
```

### Using Ledger Tip as Starting Point

```swift path=null start=null
// Get current tip and use as starting point
let tipResponse = try await client.ledgerStateQuery.tip.execute()
let currentTip = tipResponse.result

let tipPoint = Point(slot: currentTip.slot, id: currentTip.id)
let intersection = try await client.chainSync.findIntersection.execute(
    points: [tipPoint],
    id: .generateNextNanoId()
)
```

## Streaming Blocks with AsyncStream

Create an AsyncStream for efficient block processing:

```swift path=null start=null
actor ChainSyncManager {
    private let client: OgmiosClient
    private var isRunning = false
    
    init(client: OgmiosClient) {
        self.client = client
    }
    
    func createBlockStream() -> AsyncThrowingStream<ChainSyncResult, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                await self.startStreaming(continuation: continuation)
            }
        }
    }
    
    private func startStreaming(
        continuation: AsyncThrowingStream<ChainSyncResult, Error>.Continuation
    ) async {
        guard !isRunning else { return }
        isRunning = true
        
        defer { isRunning = false }
        
        do {
            // Find intersection first
            let intersection = try await client.chainSync.findIntersection.execute(
                points: [],
                id: .generateNextNanoId()
            )
            
            continuation.yield(.intersectionFound(intersection.result))
            
            // Stream blocks
            while !Task.isCancelled {
                let blockResponse = try await client.chainSync.nextBlock.execute(
                    id: .generateNextNanoId()
                )
                
                let result = ChainSyncResult.blockReceived(blockResponse.result)
                continuation.yield(result)
            }
            
        } catch {
            continuation.finish(throwing: error)
        }
    }
    
    func stop() {
        isRunning = false
    }
}

enum ChainSyncResult {
    case intersectionFound(FindIntersectionResult)
    case blockReceived(NextBlockResult)
}
```

### Using the Block Stream

```swift path=null start=null
@MainActor
class BlockchainMonitor: ObservableObject {
    @Published var currentBlock: BlockHeight = 0
    @Published var isRunning = false
    @Published var rollbackCount = 0
    
    private let chainSyncManager: ChainSyncManager
    private var streamTask: Task<Void, Never>?
    
    init(client: OgmiosClient) {
        self.chainSyncManager = ChainSyncManager(client: client)
    }
    
    func startMonitoring() {
        guard !isRunning else { return }
        
        isRunning = true
        streamTask = Task {
            do {
                let blockStream = await chainSyncManager.createBlockStream()
                
                for try await result in blockStream {
                    await handleChainSyncResult(result)
                }
            } catch {
                print("Chain sync error: \(error)")
                await MainActor.run {
                    self.isRunning = false
                }
            }
        }
    }
    
    func stopMonitoring() {
        streamTask?.cancel()
        streamTask = nil
        
        Task {
            await chainSyncManager.stop()
            await MainActor.run {
                self.isRunning = false
            }
        }
    }
    
    private func handleChainSyncResult(_ result: ChainSyncResult) async {
        switch result {
        case .intersectionFound(let intersection):
            print("Chain sync started from: \(intersection)")
            
        case .blockReceived(let blockResult):
            switch blockResult.direction {
            case .forward:
                await handleForwardBlock(blockResult.block)
            case .backward:
                await handleRollback(blockResult.block)
            }
        }
    }
    
    private func handleForwardBlock(_ block: NextBlockResult.Block) async {
        switch block {
        case .block(let blockData):
            await MainActor.run {
                self.currentBlock = blockData.header.blockHeight
            }
            
            // Process block data
            await processBlock(blockData)
            
        case .origin:
            print("Received origin marker")
        }
    }
    
    private func handleRollback(_ point: NextBlockResult.Block) async {
        await MainActor.run {
            self.rollbackCount += 1
        }
        
        print("Rollback detected: \(point)")
        
        // Handle rollback in your data store
        await rollbackToPoint(point)
    }
    
    private func processBlock(_ block: Block) async {
        print("Processing block \(block.header.blockHeight)")
        print("  Slot: \(block.header.slot)")
        print("  Hash: \(block.header.hash)")
        print("  Transactions: \(block.body?.count ?? 0)")
        
        // Extract relevant data
        if let transactions = block.body {
            for transaction in transactions {
                await processTransaction(transaction)
            }
        }
    }
    
    private func processTransaction(_ transaction: Transaction) async {
        print("  TX: \(transaction.id)")
        
        // Process inputs
        for input in transaction.body.inputs {
            print("    Input: \(input.transaction.id)#\(input.index)")
        }
        
        // Process outputs
        for (index, output) in transaction.body.outputs.enumerated() {
            print("    Output \(index): \(output.value.ada.lovelace) lovelace")
        }
    }
    
    private func rollbackToPoint(_ point: NextBlockResult.Block) async {
        // Implement rollback logic for your data store
        // This typically involves:
        // 1. Finding the rollback point in your local data
        // 2. Removing blocks/transactions after that point
        // 3. Updating your application state
        
        switch point {
        case .block(let blockData):
            print("Rolling back to block: \(blockData.header.blockHeight)")
        case .origin:
            print("Rolling back to genesis")
        }
    }
}
```

## SwiftUI Integration

```swift path=null start=null
import SwiftUI

struct ChainSyncView: View {
    @StateObject private var blockchainMonitor: BlockchainMonitor
    @State private var client: OgmiosClient?
    
    init() {
        // Initialize with placeholder, will be set in task
        let placeholderClient = try! OgmiosClient(httpOnly: false)
        self._blockchainMonitor = StateObject(wrappedValue: BlockchainMonitor(client: placeholderClient))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Status indicator
            HStack {
                Circle()
                    .fill(blockchainMonitor.isRunning ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                
                Text(blockchainMonitor.isRunning ? "Syncing" : "Stopped")
                    .font(.headline)
            }
            
            // Current block info
            VStack {
                Text("Current Block")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(blockchainMonitor.currentBlock)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            // Rollback counter
            HStack {
                Text("Rollbacks:")
                Text("\(blockchainMonitor.rollbackCount)")
                    .fontWeight(.semibold)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            // Controls
            HStack(spacing: 20) {
                Button(blockchainMonitor.isRunning ? "Stop" : "Start") {
                    if blockchainMonitor.isRunning {
                        blockchainMonitor.stopMonitoring()
                    } else {
                        blockchainMonitor.startMonitoring()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .task {
            do {
                // Initialize client on appear
                client = try await OgmiosClient(httpOnly: false)
            } catch {
                print("Failed to initialize client: \(error)")
            }
        }
    }
}
```

## Advanced Block Processing

### Filtering Relevant Transactions

```swift path=null start=null
class TransactionFilter {
    private let watchedAddresses: Set<String>
    private let watchedAssets: Set<String>
    
    init(addresses: [String] = [], assets: [String] = []) {
        self.watchedAddresses = Set(addresses)
        self.watchedAssets = Set(assets)
    }
    
    func isRelevant(_ transaction: Transaction) -> Bool {
        // Check outputs for watched addresses
        for output in transaction.body.outputs {
            if watchedAddresses.contains(output.address.value) {
                return true
            }
            
            // Check for watched native assets
            if let assets = output.value.assets {
                for (policyId, tokens) in assets {
                    for (assetName, _) in tokens {
                        let assetId = "\(policyId).\(assetName)"
                        if watchedAssets.contains(assetId) {
                            return true
                        }
                    }
                }
            }
        }
        
        // Check inputs for watched addresses (requires UTxO lookup)
        // This would typically require maintaining a UTxO set
        
        return false
    }
}

// Usage in block processing
private let transactionFilter = TransactionFilter(
    addresses: ["addr1qx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer..."],
    assets: ["3542acb3a64d80c29302260d62c3b87a742ad14abf855ebc6733081e.546f6b656e41"]
)

private func processBlock(_ block: Block) async {
    guard let transactions = block.body else { return }
    
    let relevantTransactions = transactions.filter { transaction in
        transactionFilter.isRelevant(transaction)
    }
    
    if !relevantTransactions.isEmpty {
        print("Found \(relevantTransactions.count) relevant transactions in block \(block.header.blockHeight)")
        
        for transaction in relevantTransactions {
            await handleRelevantTransaction(transaction)
        }
    }
}
```

### Building a Block Database

```swift path=null start=null
actor BlockDatabase {
    private var blocks: [BlockHeight: Block] = [:]
    private var transactions: [String: Transaction] = [:]
    private var tipHeight: BlockHeight = 0
    
    func addBlock(_ block: Block) {
        blocks[block.header.blockHeight] = block
        tipHeight = max(tipHeight, block.header.blockHeight)
        
        // Index transactions
        if let txs = block.body {
            for tx in txs {
                transactions[tx.id] = tx
            }
        }
    }
    
    func rollbackTo(_ height: BlockHeight) {
        // Remove blocks after the rollback point
        let blocksToRemove = blocks.keys.filter { $0 > height }
        
        for blockHeight in blocksToRemove {
            if let block = blocks[blockHeight] {
                // Remove transactions from this block
                if let txs = block.body {
                    for tx in txs {
                        transactions.removeValue(forKey: tx.id)
                    }
                }
                
                blocks.removeValue(forKey: blockHeight)
            }
        }
        
        tipHeight = height
    }
    
    func getBlock(at height: BlockHeight) -> Block? {
        return blocks[height]
    }
    
    func getTransaction(_ id: String) -> Transaction? {
        return transactions[id]
    }
    
    func getTipHeight() -> BlockHeight {
        return tipHeight
    }
    
    func getBlockRange(from: BlockHeight, to: BlockHeight) -> [Block] {
        return (from...to).compactMap { height in
            blocks[height]
        }
    }
}
```

## Error Handling and Resilience

```swift path=null start=null
actor ResilientChainSync {
    private let client: OgmiosClient
    private let database: BlockDatabase
    private var isRunning = false
    private let maxRetries = 3
    
    init(client: OgmiosClient) {
        self.client = client
        self.database = BlockDatabase()
    }
    
    func startSync() async {
        guard !isRunning else { return }
        isRunning = true
        
        var retryCount = 0
        
        while isRunning && retryCount < maxRetries {
            do {
                await performSync()
                retryCount = 0 // Reset on success
            } catch {
                retryCount += 1
                print("Chain sync error (attempt \(retryCount)): \(error)")
                
                if retryCount < maxRetries {
                    // Exponential backoff
                    let delay = min(pow(2.0, Double(retryCount)), 60.0)
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                } else {
                    print("Max retries exceeded, stopping sync")
                    isRunning = false
                }
            }
        }
    }
    
    private func performSync() async throws {
        // Get current tip from database to resume sync
        let currentTip = await database.getTipHeight()
        
        // Find intersection point
        let knownPoints = await buildIntersectionPoints(from: currentTip)
        let intersection = try await client.chainSync.findIntersection.execute(
            points: knownPoints,
            id: .generateNextNanoId()
        )
        
        // Handle intersection result
        switch intersection.result {
        case .intersectionFound(let point):
            print("Resuming sync from: \(point)")
        case .intersectionNotFound:
            print("No intersection found, starting from genesis")
        }
        
        // Stream blocks
        while isRunning {
            let blockResponse = try await client.chainSync.nextBlock.execute(
                id: .generateNextNanoId()
            )
            
            await handleBlockResponse(blockResponse.result)
        }
    }
    
    private func buildIntersectionPoints(from tipHeight: BlockHeight) async -> [Point] {
        // Build intersection points from recent blocks
        var points: [Point] = []
        
        // Add recent blocks for intersection finding
        for height in stride(from: tipHeight, through: max(0, tipHeight - 100), by: -10) {
            if let block = await database.getBlock(at: height) {
                let point = Point(slot: block.header.slot, id: block.header.hash)
                points.append(point)
            }
        }
        
        return points
    }
    
    private func handleBlockResponse(_ result: NextBlockResult) async {
        switch result.direction {
        case .forward:
            await handleForwardBlock(result.block)
        case .backward:
            await handleRollback(result.block)
        }
    }
    
    private func handleForwardBlock(_ block: NextBlockResult.Block) async {
        switch block {
        case .block(let blockData):
            await database.addBlock(blockData)
            print("Added block: \(blockData.header.blockHeight)")
            
        case .origin:
            print("Reached origin")
        }
    }
    
    private func handleRollback(_ point: NextBlockResult.Block) async {
        switch point {
        case .block(let blockData):
            await database.rollbackTo(blockData.header.blockHeight)
            print("Rolled back to block: \(blockData.header.blockHeight)")
            
        case .origin:
            await database.rollbackTo(0)
            print("Rolled back to genesis")
        }
    }
    
    func stop() {
        isRunning = false
    }
}
```

## Performance Considerations

### Batch Processing

```swift path=null start=null
actor BatchProcessor {
    private var pendingBlocks: [Block] = []
    private let batchSize = 10
    private let processingQueue = DispatchQueue(label: "block-processing", qos: .utility)
    
    func addBlock(_ block: Block) async {
        pendingBlocks.append(block)
        
        if pendingBlocks.count >= batchSize {
            await processBatch()
        }
    }
    
    func flush() async {
        if !pendingBlocks.isEmpty {
            await processBatch()
        }
    }
    
    private func processBatch() async {
        let batch = pendingBlocks
        pendingBlocks.removeAll()
        
        await withTaskGroup(of: Void.self) { group in
            for block in batch {
                group.addTask {
                    await self.processBlockConcurrently(block)
                }
            }
        }
    }
    
    private func processBlockConcurrently(_ block: Block) async {
        // Heavy processing work
        print("Processing block \(block.header.blockHeight) concurrently")
    }
}
```

### Memory Management

```swift path=null start=null
actor MemoryEfficientChainSync {
    private let maxBlocksInMemory = 1000
    private var blockHeights: [BlockHeight] = []
    private weak var delegate: ChainSyncDelegate?
    
    func addBlock(_ block: Block) async {
        // Process immediately to avoid memory buildup
        await delegate?.didReceiveBlock(block)
        
        blockHeights.append(block.header.blockHeight)
        
        // Cleanup old blocks if memory limit exceeded
        if blockHeights.count > maxBlocksInMemory {
            let oldestHeight = blockHeights.removeFirst()
            await delegate?.shouldCleanupBlock(at: oldestHeight)
        }
    }
}

protocol ChainSyncDelegate: Actor {
    func didReceiveBlock(_ block: Block) async
    func shouldCleanupBlock(at height: BlockHeight) async
}
```

## Testing Chain Sync

```swift path=null start=null
import XCTest
@testable import SwiftOgmios

class ChainSyncTests: XCTestCase {
    func testBasicChainSync() async throws {
        let mockClient = try await OgmiosClient(
            httpOnly: false,
            webSocketConnection: MockWebSocketConnection()
        )
        
        let manager = ChainSyncManager(client: mockClient)
        var receivedBlocks: [Block] = []
        
        let blockStream = await manager.createBlockStream()
        
        // Collect first few results
        var resultCount = 0
        for try await result in blockStream {
            switch result {
            case .blockReceived(let blockResult):
                if case .block(let block) = blockResult.block {
                    receivedBlocks.append(block)
                }
                
            case .intersectionFound(_):
                break
            }
            
            resultCount += 1
            if resultCount >= 5 { break }
        }
        
        XCTAssertGreaterThan(receivedBlocks.count, 0)
    }
    
    func testRollbackHandling() async throws {
        let database = BlockDatabase()
        
        // Add some blocks
        let block1 = createMockBlock(height: 100)
        let block2 = createMockBlock(height: 101)
        let block3 = createMockBlock(height: 102)
        
        await database.addBlock(block1)
        await database.addBlock(block2)
        await database.addBlock(block3)
        
        XCTAssertEqual(await database.getTipHeight(), 102)
        
        // Simulate rollback
        await database.rollbackTo(100)
        
        XCTAssertEqual(await database.getTipHeight(), 100)
        XCTAssertNil(await database.getBlock(at: 101))
        XCTAssertNil(await database.getBlock(at: 102))
        XCTAssertNotNil(await database.getBlock(at: 100))
    }
    
    private func createMockBlock(height: BlockHeight) -> Block {
        // Create mock block for testing
        // Implementation depends on your Block structure
        fatalError("Implement mock block creation")
    }
}
```

## Best Practices

1. **Use WebSocket Transport**: Chain sync requires persistent connections
2. **Handle Rollbacks Gracefully**: Always be prepared for chain reorganizations
3. **Implement Proper Cleanup**: Avoid memory leaks with large block streams
4. **Batch Process When Possible**: Improve performance with concurrent processing
5. **Persist Intersection Points**: Resume sync efficiently after disconnections
6. **Monitor Performance**: Track sync speed and memory usage
7. **Test Rollback Scenarios**: Ensure your application handles forks correctly

## See Also

- <doc:GettingStarted> - Basic setup and first queries
- <doc:ErrorHandling> - Handling chain sync errors and reconnections
- <doc:AdvancedUsage> - Advanced concurrency patterns for chain sync
- <doc:TransactionSubmission> - Submitting transactions after chain sync
- <doc:MempoolMonitoring> - Monitoring transactions in real-time