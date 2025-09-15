# Mempool Monitoring

Monitor transaction mempool changes in real-time and build responsive Cardano applications with live transaction tracking.

## Overview

Mempool monitoring allows you to track pending transactions before they're included in blocks. SwiftOgmios provides comprehensive mempool monitoring capabilities that let you watch for specific transactions, monitor mempool size, and build real-time applications that respond to network activity.

This tutorial covers all aspects of mempool monitoring, from basic transaction checking to advanced filtering and real-time UI integration.

## Mempool Monitoring Fundamentals

The mempool contains transactions that have been submitted to the network but not yet included in a block. The Ogmios mempool protocol provides several operations:

1. **Acquire Mempool**: Get a snapshot of the current mempool
2. **Query Transactions**: Iterate through mempool transactions
3. **Check Existence**: Verify if a specific transaction is in the mempool
4. **Monitor Size**: Track mempool capacity and usage
5. **Release Mempool**: Clean up resources

### Basic Mempool Operations

```swift path=null start=null
import SwiftOgmios

// Create client (WebSocket recommended for continuous monitoring)
let client = try await OgmiosClient(httpOnly: false)

// Acquire mempool snapshot
let snapshot = try await client.mempoolMonitor.acquireMempool.execute()
print("Acquired mempool at slot: \(snapshot.result.slot)")

// Check mempool size
let sizeResponse = try await client.mempoolMonitor.sizeOfMempool.execute()
print("Mempool size: \(sizeResponse.result.currentSize)/\(sizeResponse.result.capacity)")

// Check if specific transaction exists
let hasTransaction = try await client.mempoolMonitor.hasTransaction.execute(
    transaction: TransactionId("abc123..."),
    id: .generateNextNanoId()
)
print("Transaction in mempool: \(hasTransaction.result)")

// Release mempool snapshot
let _ = try await client.mempoolMonitor.releaseMempool.execute()
```

## Getting All Mempool Transactions

SwiftOgmios provides a convenient helper method to retrieve all transactions from the mempool:

```swift path=null start=null
do {
    let transactions = try await client.mempoolMonitor.getMempoolTransactions()
    
    print("Found \(transactions.count) transactions in mempool:")
    for transaction in transactions {
        switch transaction {
        case .transaction(let tx):
            print("  TX: \(tx.id)")
            print("    Fee: \(tx.body.fee) lovelace")
            print("    Inputs: \(tx.body.inputs.count)")
            print("    Outputs: \(tx.body.outputs.count)")
        case .noMoreTransactions:
            break
        }
    }
} catch {
    print("Failed to get mempool transactions: \(error)")
}
```

## Advanced Mempool Monitoring

### Real-Time Mempool Monitor

```swift path=null start=null
actor MempoolMonitor {
    private let client: OgmiosClient
    private var isMonitoring = false
    private var monitoringTask: Task<Void, Never>?
    
    init(client: OgmiosClient) {
        self.client = client
    }
    
    func startMonitoring() async {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        monitoringTask = Task { [weak self] in
            await self?.monitorLoop()
        }
    }
    
    func stopMonitoring() {
        isMonitoring = false
        monitoringTask?.cancel()
        monitoringTask = nil
    }
    
    private func monitorLoop() async {
        while isMonitoring && !Task.isCancelled {
            do {
                // Check mempool size
                let sizeResponse = try await client.mempoolMonitor.sizeOfMempool.execute()
                await handleSizeUpdate(sizeResponse.result)
                
                // Get current transactions
                let transactions = try await client.mempoolMonitor.getMempoolTransactions()
                await handleTransactionUpdate(transactions)
                
                // Wait before next check
                try await Task.sleep(nanoseconds: 30_000_000_000) // 30 seconds
                
            } catch {
                print("Mempool monitoring error: \(error)")
                
                // Wait before retry
                try? await Task.sleep(nanoseconds: 10_000_000_000) // 10 seconds
            }
        }
    }
    
    private func handleSizeUpdate(_ size: SizeAndCapacity) async {
        let utilization = Double(size.currentSize) / Double(size.capacity) * 100
        print("Mempool utilization: \(String(format: "%.1f", utilization))% (\(size.currentSize)/\(size.capacity))")
    }
    
    private func handleTransactionUpdate(_ transactions: [NextTransactionResult]) async {
        var txCount = 0
        var totalFees: UInt64 = 0
        
        for transaction in transactions {
            if case .transaction(let tx) = transaction {
                txCount += 1
                totalFees += tx.body.fee
            }
        }
        
        let avgFee = txCount > 0 ? totalFees / UInt64(txCount) : 0
        print("Mempool stats: \(txCount) transactions, avg fee: \(avgFee) lovelace")
    }
}
```

### Transaction Filtering

Create filters to monitor specific types of transactions:

```swift path=null start=null
struct TransactionFilter {
    let watchedAddresses: Set<String>
    let watchedAssets: Set<String>
    let minAmount: UInt64?
    let maxAmount: UInt64?
    
    init(
        addresses: [String] = [],
        assets: [String] = [],
        minAmount: UInt64? = nil,
        maxAmount: UInt64? = nil
    ) {
        self.watchedAddresses = Set(addresses)
        self.watchedAssets = Set(assets)
        self.minAmount = minAmount
        self.maxAmount = maxAmount
    }
    
    func matches(_ transaction: Transaction) -> Bool {
        // Check addresses
        if !watchedAddresses.isEmpty {
            let hasMatchingAddress = transaction.body.outputs.contains { output in
                watchedAddresses.contains(output.address.value)
            }
            if !hasMatchingAddress {
                return false
            }
        }
        
        // Check assets
        if !watchedAssets.isEmpty {
            let hasMatchingAsset = transaction.body.outputs.contains { output in
                guard let assets = output.value.assets else { return false }
                
                return assets.contains { (policyId, tokens) in
                    tokens.contains { (assetName, _) in
                        let assetId = "\(policyId).\(assetName)"
                        return watchedAssets.contains(assetId)
                    }
                }
            }
            if !hasMatchingAsset {
                return false
            }
        }
        
        // Check amount range
        let totalOutput = transaction.body.outputs.reduce(0) { sum, output in
            sum + output.value.ada.lovelace
        }
        
        if let minAmount = minAmount, totalOutput < minAmount {
            return false
        }
        
        if let maxAmount = maxAmount, totalOutput > maxAmount {
            return false
        }
        
        return true
    }
}

// Usage
let filter = TransactionFilter(
    addresses: ["addr1qx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer..."],
    minAmount: 1_000_000 // 1 ADA minimum
)

let allTransactions = try await client.mempoolMonitor.getMempoolTransactions()
let filteredTransactions = allTransactions.compactMap { result -> Transaction? in
    guard case .transaction(let tx) = result else { return nil }
    return filter.matches(tx) ? tx : nil
}

print("Found \(filteredTransactions.count) matching transactions")
```

### Smart Mempool Observer

```swift path=null start=null
@MainActor
class SmartMempoolObserver: ObservableObject {
    @Published var mempoolSize: SizeAndCapacity?
    @Published var recentTransactions: [Transaction] = []
    @Published var watchedTransactions: [String: TransactionStatus] = [:]
    @Published var isMonitoring = false
    
    private let client: OgmiosClient
    private let filter: TransactionFilter
    private var monitoringTask: Task<Void, Never>?
    private var lastSnapshot: Set<String> = []
    
    enum TransactionStatus {
        case pending(since: Date)
        case confirmed(at: Date)
        case dropped(at: Date)
    }
    
    init(client: OgmiosClient, filter: TransactionFilter = TransactionFilter()) {
        self.client = client
        self.filter = filter
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        monitoringTask = Task { [weak self] in
            while !Task.isCancelled {
                await self?.performMonitoringCycle()
                
                // Wait before next cycle
                try? await Task.sleep(nanoseconds: 15_000_000_000) // 15 seconds
            }
        }
    }
    
    func stopMonitoring() {
        isMonitoring = false
        monitoringTask?.cancel()
        monitoringTask = nil
    }
    
    func watchTransaction(_ transactionId: String) {
        watchedTransactions[transactionId] = .pending(since: Date())
    }
    
    private func performMonitoringCycle() async {
        do {
            // Update mempool size
            let sizeResponse = try await client.mempoolMonitor.sizeOfMempool.execute()
            await MainActor.run {
                self.mempoolSize = sizeResponse.result
            }
            
            // Get current transactions
            let allTransactions = try await client.mempoolMonitor.getMempoolTransactions()
            let currentSnapshot = Set(allTransactions.compactMap { result in
                guard case .transaction(let tx) = result else { return nil }
                return tx.id
            })
            
            // Detect new transactions
            let newTransactions = currentSnapshot.subtracting(lastSnapshot)
            if !newTransactions.isEmpty {
                await handleNewTransactions(newTransactions, from: allTransactions)
            }
            
            // Detect dropped transactions
            let droppedTransactions = lastSnapshot.subtracting(currentSnapshot)
            if !droppedTransactions.isEmpty {
                await handleDroppedTransactions(droppedTransactions)
            }
            
            // Update watched transactions
            await updateWatchedTransactions(currentSnapshot)
            
            lastSnapshot = currentSnapshot
            
        } catch {
            print("Monitoring cycle error: \(error)")
        }
    }
    
    private func handleNewTransactions(_ newTxIds: Set<String>, from allTransactions: [NextTransactionResult]) async {
        let newTxs = allTransactions.compactMap { result -> Transaction? in
            guard case .transaction(let tx) = result else { return nil }
            return newTxIds.contains(tx.id) ? tx : nil
        }
        
        let filteredNewTxs = newTxs.filter { filter.matches($0) }
        
        await MainActor.run {
            // Add to recent transactions (keep last 20)
            self.recentTransactions.insert(contentsOf: filteredNewTxs, at: 0)
            if self.recentTransactions.count > 20 {
                self.recentTransactions = Array(self.recentTransactions.prefix(20))
            }
        }
        
        // Notify about new transactions
        for tx in filteredNewTxs {
            print("New transaction: \(tx.id)")
            await handleNewTransaction(tx)
        }
    }
    
    private func handleDroppedTransactions(_ droppedTxIds: Set<String>) async {
        await MainActor.run {
            // Remove from recent transactions
            self.recentTransactions.removeAll { tx in
                droppedTxIds.contains(tx.id)
            }
        }
        
        for txId in droppedTxIds {
            print("Transaction dropped from mempool: \(txId)")
        }
    }
    
    private func updateWatchedTransactions(_ currentSnapshot: Set<String>) async {
        await MainActor.run {
            for (txId, status) in self.watchedTransactions {
                switch status {
                case .pending(_):
                    if !currentSnapshot.contains(txId) {
                        // Transaction left mempool - likely confirmed
                        self.watchedTransactions[txId] = .confirmed(at: Date())
                    }
                case .confirmed(_), .dropped(_):
                    // Keep confirmed/dropped status
                    break
                }
            }
        }
    }
    
    private func handleNewTransaction(_ transaction: Transaction) async {
        // Analyze transaction
        let totalOutput = transaction.body.outputs.reduce(0) { sum, output in
            sum + output.value.ada.lovelace
        }
        
        print("  Fee: \(transaction.body.fee) lovelace")
        print("  Total output: \(totalOutput) lovelace")
        print("  Inputs: \(transaction.body.inputs.count)")
        print("  Outputs: \(transaction.body.outputs.count)")
        
        // Check for interesting patterns
        if transaction.body.fee > 1_000_000 { // High fee (> 1 ADA)
            print("  ⚠️ High fee transaction detected!")
        }
        
        if transaction.body.outputs.count > 100 {
            print("  📊 Large transaction with many outputs")
        }
        
        // Check for native assets
        let hasNativeAssets = transaction.body.outputs.contains { output in
            output.value.assets != nil
        }
        if hasNativeAssets {
            print("  🎨 Contains native assets")
        }
    }
}
```

## Real-Time SwiftUI Integration

### Mempool Dashboard View

```swift path=null start=null
import SwiftUI

struct MempoolDashboardView: View {
    @StateObject private var observer: SmartMempoolObserver
    @State private var selectedFilter = FilterType.all
    @State private var watchedTxId = ""
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case highFee = "High Fee"
        case largeAmount = "Large Amount"
        case nativeAssets = "Native Assets"
    }
    
    init(client: OgmiosClient) {
        self._observer = StateObject(wrappedValue: SmartMempoolObserver(client: client))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header with monitoring status
                headerView
                
                // Mempool stats
                if let size = observer.mempoolSize {
                    mempoolStatsView(size)
                }
                
                // Transaction filter
                filterView
                
                // Recent transactions list
                transactionListView
                
                // Transaction watcher
                transactionWatcherView
            }
            .padding()
            .navigationTitle("Mempool Monitor")
            .onAppear {
                observer.startMonitoring()
            }
            .onDisappear {
                observer.stopMonitoring()
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Circle()
                .fill(observer.isMonitoring ? Color.green : Color.red)
                .frame(width: 12, height: 12)
            
            Text(observer.isMonitoring ? "Monitoring" : "Stopped")
                .font(.headline)
            
            Spacer()
            
            Button(observer.isMonitoring ? "Stop" : "Start") {
                if observer.isMonitoring {
                    observer.stopMonitoring()
                } else {
                    observer.startMonitoring()
                }
            }
            .buttonStyle(.bordered)
        }
    }
    
    @ViewBuilder
    private func mempoolStatsView(_ size: SizeAndCapacity) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("Mempool Size")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(size.currentSize) / \(size.capacity)")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            ProgressView(
                value: Double(size.currentSize),
                total: Double(size.capacity)
            )
            
            let utilization = Double(size.currentSize) / Double(size.capacity) * 100
            Text("\(String(format: "%.1f", utilization))% full")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    @ViewBuilder
    private var filterView: some View {
        VStack {
            Text("Filter Transactions")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Picker("Filter", selection: $selectedFilter) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    private var transactionListView: some View {
        VStack(alignment: .leading) {
            Text("Recent Transactions")
                .font(.headline)
            
            if observer.recentTransactions.isEmpty {
                Text("No transactions yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                List(filteredTransactions, id: \.id) { transaction in
                    TransactionRowView(transaction: transaction)
                }
                .listStyle(.plain)
                .frame(maxHeight: 300)
            }
        }
    }
    
    @ViewBuilder
    private var transactionWatcherView: some View {
        VStack(alignment: .leading) {
            Text("Watch Transaction")
                .font(.headline)
            
            HStack {
                TextField("Transaction ID", text: $watchedTxId)
                    .textFieldStyle(.roundedBorder)
                
                Button("Watch") {
                    observer.watchTransaction(watchedTxId)
                    watchedTxId = ""
                }
                .disabled(watchedTxId.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            
            // Watched transactions status
            if !observer.watchedTransactions.isEmpty {
                ForEach(Array(observer.watchedTransactions.keys), id: \.self) { txId in
                    if let status = observer.watchedTransactions[txId] {
                        WatchedTransactionView(transactionId: txId, status: status)
                    }
                }
            }
        }
    }
    
    private var filteredTransactions: [Transaction] {
        observer.recentTransactions.filter { transaction in
            switch selectedFilter {
            case .all:
                return true
            case .highFee:
                return transaction.body.fee > 1_000_000 // > 1 ADA
            case .largeAmount:
                let totalOutput = transaction.body.outputs.reduce(0) { sum, output in
                    sum + output.value.ada.lovelace
                }
                return totalOutput > 10_000_000 // > 10 ADA
            case .nativeAssets:
                return transaction.body.outputs.contains { output in
                    output.value.assets != nil
                }
            }
        }
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(transaction.id)
                    .font(.system(.caption, design: .monospaced))
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                Spacer()
                
                Text("\(transaction.body.fee) lovelace")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("\(transaction.body.inputs.count) inputs")
                Text("•")
                Text("\(transaction.body.outputs.count) outputs")
                
                Spacer()
                
                if transaction.body.outputs.contains(where: { $0.value.assets != nil }) {
                    Image(systemName: "paintbrush.fill")
                        .foregroundColor(.purple)
                        .font(.caption2)
                }
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

struct WatchedTransactionView: View {
    let transactionId: String
    let status: SmartMempoolObserver.TransactionStatus
    
    var body: some View {
        HStack {
            statusIcon
            
            VStack(alignment: .leading) {
                Text(transactionId)
                    .font(.system(.caption, design: .monospaced))
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                Text(statusText)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        switch status {
        case .pending(_):
            Image(systemName: "clock")
                .foregroundColor(.orange)
        case .confirmed(_):
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .dropped(_):
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        }
    }
    
    private var statusText: String {
        switch status {
        case .pending(let date):
            return "Pending since \(date.formatted(.dateTime.hour().minute()))"
        case .confirmed(let date):
            return "Confirmed at \(date.formatted(.dateTime.hour().minute()))"
        case .dropped(let date):
            return "Dropped at \(date.formatted(.dateTime.hour().minute()))"
        }
    }
}
```

## Performance Optimizations

### Efficient Mempool Polling

```swift path=null start=null
actor EfficientMempoolMonitor {
    private let client: OgmiosClient
    private var lastKnownSize: Int = 0
    private var pollInterval: TimeInterval = 30.0 // Start with 30 seconds
    private let minPollInterval: TimeInterval = 5.0
    private let maxPollInterval: TimeInterval = 120.0
    
    init(client: OgmiosClient) {
        self.client = client
    }
    
    func adaptiveMonitoring() async {
        while !Task.isCancelled {
            do {
                // Check mempool size first (lightweight operation)
                let sizeResponse = try await client.mempoolMonitor.sizeOfMempool.execute()
                let currentSize = sizeResponse.result.currentSize
                
                // Adapt polling interval based on activity
                if currentSize != lastKnownSize {
                    // Activity detected - increase polling frequency
                    pollInterval = max(pollInterval * 0.8, minPollInterval)
                    
                    // Full mempool scan on changes
                    await performFullScan()
                } else {
                    // No changes - decrease polling frequency
                    pollInterval = min(pollInterval * 1.2, maxPollInterval)
                }
                
                lastKnownSize = currentSize
                
                print("Next poll in \(String(format: "%.1f", pollInterval)) seconds")
                try await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
                
            } catch {
                print("Adaptive monitoring error: \(error)")
                try await Task.sleep(nanoseconds: 10_000_000_000) // 10 seconds on error
            }
        }
    }
    
    private func performFullScan() async {
        do {
            let transactions = try await client.mempoolMonitor.getMempoolTransactions()
            print("Full scan found \(transactions.count) transactions")
            
            // Process interesting transactions
            await analyzeTransactions(transactions)
            
        } catch {
            print("Full scan error: \(error)")
        }
    }
    
    private func analyzeTransactions(_ transactions: [NextTransactionResult]) async {
        var highFeeCount = 0
        var nativeAssetCount = 0
        var totalFees: UInt64 = 0
        
        for result in transactions {
            guard case .transaction(let tx) = result else { continue }
            
            totalFees += tx.body.fee
            
            if tx.body.fee > 1_000_000 { // > 1 ADA
                highFeeCount += 1
            }
            
            let hasAssets = tx.body.outputs.contains { output in
                output.value.assets != nil
            }
            if hasAssets {
                nativeAssetCount += 1
            }
        }
        
        let avgFee = transactions.count > 0 ? totalFees / UInt64(transactions.count) : 0
        
        print("Analysis: \(highFeeCount) high-fee, \(nativeAssetCount) with assets, avg fee: \(avgFee) lovelace")
    }
}
```

### Batch Transaction Processing

```swift path=null start=null
actor BatchMempoolProcessor {
    private let client: OgmiosClient
    private let batchSize = 50
    private var processingQueue: [Transaction] = []
    
    init(client: OgmiosClient) {
        self.client = client
    }
    
    func processMempoolInBatches() async {
        do {
            let allTransactions = try await client.mempoolMonitor.getMempoolTransactions()
            
            let transactions = allTransactions.compactMap { result -> Transaction? in
                guard case .transaction(let tx) = result else { return nil }
                return tx
            }
            
            // Process in batches to avoid memory pressure
            for batch in transactions.chunked(into: batchSize) {
                await processBatch(batch)
                
                // Small delay between batches to prevent overwhelming
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            }
            
        } catch {
            print("Batch processing error: \(error)")
        }
    }
    
    private func processBatch(_ transactions: [Transaction]) async {
        await withTaskGroup(of: Void.self) { group in
            for transaction in transactions {
                group.addTask {
                    await self.processTransaction(transaction)
                }
            }
        }
    }
    
    private func processTransaction(_ transaction: Transaction) async {
        // Heavy processing work here
        // e.g., database updates, notifications, analysis
        print("Processing \(transaction.id)")
    }
}

// Array extension for chunking
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
```

## Testing Mempool Monitoring

```swift path=null start=null
import XCTest
@testable import SwiftOgmios

class MempoolMonitoringTests: XCTestCase {
    var client: OgmiosClient!
    var observer: SmartMempoolObserver!
    
    override func setUp() async throws {
        client = try await OgmiosClient(
            httpOnly: false,
            webSocketConnection: MockWebSocketConnection()
        )
        observer = SmartMempoolObserver(client: client)
    }
    
    func testBasicMempoolOperations() async throws {
        // Test acquiring mempool
        let snapshot = try await client.mempoolMonitor.acquireMempool.execute()
        XCTAssertNotNil(snapshot.result.slot)
        
        // Test getting size
        let size = try await client.mempoolMonitor.sizeOfMempool.execute()
        XCTAssertGreaterThanOrEqual(size.result.currentSize, 0)
        XCTAssertGreaterThan(size.result.capacity, 0)
        
        // Test checking transaction existence
        let hasTransaction = try await client.mempoolMonitor.hasTransaction.execute(
            transaction: TransactionId("test-tx-id"),
            id: .generateNextNanoId()
        )
        XCTAssertNotNil(hasTransaction.result)
        
        // Test releasing mempool
        let release = try await client.mempoolMonitor.releaseMempool.execute()
        XCTAssertNotNil(release)
    }
    
    func testTransactionFilter() {
        let filter = TransactionFilter(
            addresses: ["addr1test123"],
            minAmount: 1_000_000
        )
        
        // Create test transaction
        let mockTransaction = createMockTransaction(
            outputs: [
                createMockOutput(address: "addr1test123", amount: 2_000_000)
            ]
        )
        
        XCTAssertTrue(filter.matches(mockTransaction))
        
        // Test with different address
        let mockTransaction2 = createMockTransaction(
            outputs: [
                createMockOutput(address: "addr1different", amount: 2_000_000)
            ]
        )
        
        XCTAssertFalse(filter.matches(mockTransaction2))
    }
    
    func testMempoolObserver() async throws {
        // Start monitoring
        await observer.startMonitoring()
        XCTAssertTrue(observer.isMonitoring)
        
        // Wait for some monitoring cycles
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Stop monitoring
        await observer.stopMonitoring()
        XCTAssertFalse(observer.isMonitoring)
    }
    
    private func createMockTransaction(outputs: [TransactionOutput]) -> Transaction {
        // Create mock transaction for testing
        // Implementation depends on your Transaction structure
        fatalError("Implement mock transaction creation")
    }
    
    private func createMockOutput(address: String, amount: UInt64) -> TransactionOutput {
        // Create mock transaction output
        fatalError("Implement mock output creation")
    }
}
```

## Best Practices

1. **Use WebSocket Transport**: Mempool monitoring works better with persistent connections
2. **Implement Adaptive Polling**: Adjust polling frequency based on mempool activity
3. **Filter Early**: Apply filters to reduce processing overhead
4. **Handle Connection Issues**: Implement reconnection logic for reliable monitoring
5. **Batch Processing**: Process large transaction sets in batches
6. **Memory Management**: Clean up old data to prevent memory leaks
7. **Rate Limiting**: Respect server resources with appropriate polling intervals
8. **User Feedback**: Provide clear status indicators in UI applications

## Use Cases

- **Transaction Status Tracking**: Monitor specific transactions until confirmation
- **Fee Market Analysis**: Track fee trends and mempool congestion
- **DApp Activity Monitoring**: Watch for transactions involving your smart contracts
- **Arbitrage Opportunities**: Monitor for specific transaction patterns
- **Network Health Monitoring**: Track mempool size and transaction throughput
- **Real-time Notifications**: Alert users about relevant transactions

## See Also

- <doc:GettingStarted> - Basic setup and first operations
- <doc:TransactionSubmission> - Submitting transactions to monitor
- <doc:ChainSynchronization> - Confirming mempool transactions in blocks
- <doc:ErrorHandling> - Handling mempool monitoring errors
- <doc:TransportTypes> - Optimizing connection types for monitoring