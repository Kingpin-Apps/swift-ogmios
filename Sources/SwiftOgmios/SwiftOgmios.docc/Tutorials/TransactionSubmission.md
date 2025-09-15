# Transaction Submission

Learn how to submit transactions to the Cardano network using SwiftOgmios with comprehensive error handling and confirmation monitoring.

## Overview

Transaction submission is a critical component of Cardano applications. SwiftOgmios provides robust transaction submission capabilities with detailed error mapping, retry mechanisms, and confirmation monitoring. This tutorial covers the complete transaction submission workflow from building to confirmation.

> **Note**: This tutorial assumes you're using SwiftCardanoTxBuilder for transaction construction. You can also use other transaction building libraries or construct transactions manually.

## Transaction Submission Workflow

1. **Build Transaction**: Create transaction using transaction builder
2. **Submit Transaction**: Send to network via Ogmios
3. **Handle Errors**: Process submission errors with specific recovery strategies
4. **Monitor Confirmation**: Track transaction confirmation status
5. **Handle Rollbacks**: Deal with chain reorganizations affecting your transaction

## Basic Transaction Submission

### Simple Submission

```swift path=null start=null
import SwiftOgmios

// Create client (HTTP or WebSocket both work for submission)
let client = try await OgmiosClient(httpOnly: true)

// Your transaction CBOR bytes (from transaction builder)
let transactionCBOR = Data(/* your transaction bytes */)

do {
    let response = try await client.transactionSubmission.submitTransaction.execute(
        transaction: transactionCBOR,
        id: .generateNextNanoId()
    )
    
    print("Transaction submitted successfully!")
    print("Transaction ID: \(response.result)")
    
} catch {
    print("Transaction submission failed: \(error)")
}
```

### Transaction Building Integration

```swift path=null start=null
import SwiftCardanoTxBuilder // Assumed transaction builder library

class TransactionService {
    private let client: OgmiosClient
    private let txBuilder: TransactionBuilder
    
    init(client: OgmiosClient) {
        self.client = client
        self.txBuilder = TransactionBuilder()
    }
    
    func sendAda(
        from senderKey: PrivateKey,
        to recipientAddress: Address,
        amount: Lovelace,
        changeAddress: Address
    ) async throws -> String {
        // 1. Get protocol parameters for fee calculation
        let protocolParams = try await client.ledgerStateQuery.protocolParameters.execute()
        
        // 2. Get UTxOs for the sender
        let utxoResponse = try await client.ledgerStateQuery.utxo.execute(
            addresses: [senderKey.publicKey.address],
            id: .generateNextNanoId()
        )
        
        // 3. Build transaction
        let transaction = try txBuilder
            .addInputs(from: utxoResponse.result)
            .addOutput(address: recipientAddress, amount: amount)
            .addOutput(address: changeAddress, amount: .calculateChange)
            .calculateFee(using: protocolParams.result)
            .sign(with: senderKey)
            .build()
        
        // 4. Submit transaction
        let submitResponse = try await client.transactionSubmission.submitTransaction.execute(
            transaction: transaction.toCBOR(),
            id: .generateNextNanoId()
        )
        
        return submitResponse.result
    }
}
```

## Comprehensive Error Handling

Transaction submission can fail for many reasons. SwiftOgmios provides detailed error mapping for all Ogmios transaction submission error codes:

### Error Code Mapping

```swift path=null start=null
enum TransactionSubmissionError: Error, LocalizedError {
    case eraMismatch
    case invalidSignatures
    case missingSignatures
    case missingScripts
    case feeTooSmall(required: UInt64, provided: UInt64)
    case valueNotConserved
    case unknownOutputReference
    case transactionTooLarge(size: Int, limit: Int)
    case networkError(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .eraMismatch:
            return "Transaction not valid in current era"
        case .invalidSignatures:
            return "Transaction signatures are invalid"
        case .missingSignatures:
            return "Required signatures are missing"
        case .missingScripts:
            return "Required script witnesses are missing"
        case .feeTooSmall(let required, let provided):
            return "Fee too small: required \(required), provided \(provided)"
        case .valueNotConserved:
            return "Input and output values don't match"
        case .unknownOutputReference:
            return "Referenced UTxO not found"
        case .transactionTooLarge(let size, let limit):
            return "Transaction too large: \(size) bytes (limit: \(limit))"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
    
    var recoveryStrategy: RecoveryStrategy {
        switch self {
        case .eraMismatch:
            return .rebuildTransaction
        case .invalidSignatures, .missingSignatures:
            return .fixSignatures
        case .missingScripts:
            return .addScripts
        case .feeTooSmall:
            return .increaseFee
        case .valueNotConserved:
            return .fixBalance
        case .unknownOutputReference:
            return .refreshUtxos
        case .transactionTooLarge:
            return .optimizeTransaction
        case .networkError:
            return .retry
        case .unknownError:
            return .investigate
        }
    }
}

enum RecoveryStrategy {
    case rebuildTransaction
    case fixSignatures
    case addScripts
    case increaseFee
    case fixBalance
    case refreshUtxos
    case optimizeTransaction
    case retry
    case investigate
}
```

### Error Processing Function

```swift path=null start=null
extension TransactionService {
    func processSubmissionError(_ error: Error) -> TransactionSubmissionError {
        guard let ogmiosError = error as? OgmiosError,
              case .responseError(let message) = ogmiosError else {
            return .networkError(error.localizedDescription)
        }
        
        // Parse error code from message
        let errorCode = extractErrorCode(from: message)
        
        switch errorCode {
        case 3005:
            return .eraMismatch
        case 3100:
            return .invalidSignatures
        case 3101:
            return .missingSignatures
        case 3102:
            return .missingScripts
        case 3122:
            let (required, provided) = extractFeeInfo(from: message)
            return .feeTooSmall(required: required, provided: provided)
        case 3123:
            return .valueNotConserved
        case 3117:
            return .unknownOutputReference
        case 3119:
            let (size, limit) = extractSizeInfo(from: message)
            return .transactionTooLarge(size: size, limit: limit)
        default:
            return .unknownError(message)
        }
    }
    
    private func extractErrorCode(from message: String) -> Int {
        // Extract 4-digit error code from message
        let pattern = #"(\d{4})"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(message.startIndex..<message.endIndex, in: message)
        
        if let match = regex.firstMatch(in: message, options: [], range: range) {
            let codeRange = Range(match.range(at: 1), in: message)!
            return Int(String(message[codeRange])) ?? 0
        }
        
        return 0
    }
    
    private func extractFeeInfo(from message: String) -> (required: UInt64, provided: UInt64) {
        // Parse fee information from error message
        // Implementation depends on specific error message format
        return (required: 0, provided: 0)
    }
    
    private func extractSizeInfo(from message: String) -> (size: Int, limit: Int) {
        // Parse size information from error message
        return (size: 0, limit: 0)
    }
}
```

## Retry Mechanisms with Backoff

### Intelligent Retry Strategy

```swift path=null start=null
class ResilientTransactionSubmitter {
    private let client: OgmiosClient
    private let maxRetries: Int
    private let baseDelay: TimeInterval
    
    init(client: OgmiosClient, maxRetries: Int = 3, baseDelay: TimeInterval = 1.0) {
        self.client = client
        self.maxRetries = maxRetries
        self.baseDelay = baseDelay
    }
    
    func submitWithRetry(
        transaction: Data,
        onRetry: ((TransactionSubmissionError, Int) -> Void)? = nil
    ) async throws -> String {
        var lastError: TransactionSubmissionError?
        
        for attempt in 1...maxRetries {
            do {
                let response = try await client.transactionSubmission.submitTransaction.execute(
                    transaction: transaction,
                    id: .generateNextNanoId()
                )
                
                return response.result
                
            } catch {
                let submissionError = processSubmissionError(error)
                lastError = submissionError
                
                // Check if error is retryable
                if !submissionError.isRetryable || attempt == maxRetries {
                    throw submissionError
                }
                
                // Notify caller of retry attempt
                onRetry?(submissionError, attempt)
                
                // Calculate delay with exponential backoff
                let delay = baseDelay * pow(2.0, Double(attempt - 1))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        throw lastError ?? TransactionSubmissionError.unknownError("Max retries exceeded")
    }
    
    private func processSubmissionError(_ error: Error) -> TransactionSubmissionError {
        // Implementation from previous example
        return .networkError(error.localizedDescription)
    }
}

extension TransactionSubmissionError {
    var isRetryable: Bool {
        switch self {
        case .networkError:
            return true
        case .unknownOutputReference:
            return true // UTxO might become available
        case .feeTooSmall:
            return false // Needs manual fix
        case .invalidSignatures, .missingSignatures:
            return false // Needs manual fix
        case .valueNotConserved:
            return false // Needs manual fix
        case .transactionTooLarge:
            return false // Needs optimization
        case .eraMismatch:
            return true // Era might change
        case .missingScripts:
            return false // Needs manual fix
        case .unknownError:
            return true // Might be temporary
        }
    }
}
```

### Usage Example

```swift path=null start=null
let submitter = ResilientTransactionSubmitter(client: client)

do {
    let txId = try await submitter.submitWithRetry(
        transaction: transactionCBOR
    ) { error, attempt in
        print("Attempt \(attempt) failed: \(error.localizedDescription)")
        
        // Handle specific errors
        switch error.recoveryStrategy {
        case .retry:
            print("  Retrying...")
        case .increaseFee:
            print("  Consider increasing the fee")
        case .refreshUtxos:
            print("  UTxO set might have changed, consider refreshing")
        default:
            print("  Manual intervention required")
        }
    }
    
    print("Transaction submitted: \(txId)")
    
} catch let error as TransactionSubmissionError {
    print("Final submission error: \(error.localizedDescription)")
    
    // Provide user guidance based on error type
    switch error.recoveryStrategy {
    case .increaseFee:
        print("Please increase the transaction fee and try again")
    case .fixBalance:
        print("Please check transaction inputs and outputs")
    case .fixSignatures:
        print("Please verify transaction signatures")
    default:
        print("Please check transaction details and try again")
    }
}
```

## Transaction Confirmation Monitoring

### Basic Confirmation Check

```swift path=null start=null
class TransactionMonitor {
    private let client: OgmiosClient
    
    init(client: OgmiosClient) {
        self.client = client
    }
    
    func waitForConfirmation(
        transactionId: String,
        requiredConfirmations: Int = 1,
        timeoutSeconds: TimeInterval = 300
    ) async throws -> Bool {
        let startTime = Date()
        
        while Date().timeIntervalSince(startTime) < timeoutSeconds {
            // Check if transaction exists in mempool
            let mempoolResponse = try await client.mempoolMonitor.hasTransaction.execute(
                transaction: TransactionId(transactionId),
                id: .generateNextNanoId()
            )
            
            if mempoolResponse.result {
                print("Transaction \(transactionId) is in mempool")
                
                // Wait a bit and check again
                try await Task.sleep(nanoseconds: 10_000_000_000) // 10 seconds
                continue
            }
            
            // Transaction not in mempool, check if it's confirmed
            let confirmations = try await getConfirmationCount(transactionId: transactionId)
            
            if confirmations >= requiredConfirmations {
                print("Transaction \(transactionId) confirmed with \(confirmations) confirmations")
                return true
            }
            
            // Wait before next check
            try await Task.sleep(nanoseconds: 20_000_000_000) // 20 seconds
        }
        
        throw TransactionMonitorError.timeout
    }
    
    private func getConfirmationCount(transactionId: String) async throws -> Int {
        // Get current tip
        let tipResponse = try await client.ledgerStateQuery.tip.execute()
        let currentHeight = tipResponse.result.height
        
        // Find transaction block (this is simplified - in practice you'd need to
        // maintain a transaction index or use chain sync to track transactions)
        
        // For this example, we'll assume the transaction was found at a specific height
        // In a real implementation, you would:
        // 1. Use chain sync to track transactions
        // 2. Maintain a database of transaction locations
        // 3. Or use external indexing services
        
        return 0 // Placeholder - implement based on your transaction tracking strategy
    }
}

enum TransactionMonitorError: Error {
    case timeout
    case notFound
}
```

### Advanced Confirmation with Chain Sync

```swift path=null start=null
actor TransactionTracker {
    private var trackedTransactions: [String: TransactionStatus] = [:]
    private let client: OgmiosClient
    
    struct TransactionStatus {
        let transactionId: String
        var blockHeight: BlockHeight?
        var confirmations: Int = 0
        var isRolledBack = false
        let submissionTime: Date
    }
    
    init(client: OgmiosClient) {
        self.client = client
    }
    
    func trackTransaction(_ transactionId: String) {
        trackedTransactions[transactionId] = TransactionStatus(
            transactionId: transactionId,
            submissionTime: Date()
        )
    }
    
    func processBlock(_ block: Block, currentTip: BlockHeight) {
        guard let transactions = block.body else { return }
        
        // Check if any tracked transactions are in this block
        for transaction in transactions {
            if let status = trackedTransactions[transaction.id] {
                var updatedStatus = status
                updatedStatus.blockHeight = block.header.blockHeight
                updatedStatus.confirmations = Int(currentTip - block.header.blockHeight) + 1
                updatedStatus.isRolledBack = false
                
                trackedTransactions[transaction.id] = updatedStatus
                
                print("Transaction \(transaction.id) confirmed in block \(block.header.blockHeight)")
            }
        }
    }
    
    func handleRollback(to height: BlockHeight) {
        // Mark transactions in rolled-back blocks
        for (txId, var status) in trackedTransactions {
            if let blockHeight = status.blockHeight, blockHeight > height {
                status.isRolledBack = true
                status.blockHeight = nil
                status.confirmations = 0
                trackedTransactions[txId] = status
                
                print("Transaction \(txId) rolled back")
            }
        }
    }
    
    func getStatus(for transactionId: String) -> TransactionStatus? {
        return trackedTransactions[transactionId]
    }
    
    func removeTransaction(_ transactionId: String) {
        trackedTransactions.removeValue(forKey: transactionId)
    }
}
```

## Transaction Evaluation

Before submitting a transaction, you can evaluate it to estimate execution costs and detect potential issues:

### Basic Transaction Evaluation

```swift path=null start=null
func evaluateTransaction(
    transaction: Data,
    additionalUtxo: [TransactionInput: TransactionOutput] = [:]
) async throws -> EvaluationResult {
    let response = try await client.transactionSubmission.evaluateTransaction.execute(
        transaction: transaction,
        additionalUtxo: additionalUtxo,
        id: .generateNextNanoId()
    )
    
    return response.result
}

// Usage
do {
    let evaluation = try await evaluateTransaction(transaction: transactionCBOR)
    
    print("Evaluation successful:")
    for (redeemer, budget) in evaluation {
        print("  Redeemer: \(redeemer)")
        print("    CPU: \(budget.cpu) steps")
        print("    Memory: \(budget.memory) units")
    }
    
} catch {
    print("Evaluation failed: \(error)")
    // Transaction would fail if submitted
}
```

### Pre-Submission Validation

```swift path=null start=null
class TransactionValidator {
    private let client: OgmiosClient
    
    init(client: OgmiosClient) {
        self.client = client
    }
    
    func validateBeforeSubmission(transaction: Data) async throws -> ValidationResult {
        var issues: [ValidationIssue] = []
        
        // 1. Evaluate transaction execution
        do {
            let evaluation = try await client.transactionSubmission.evaluateTransaction.execute(
                transaction: transaction,
                additionalUtxo: [:],
                id: .generateNextNanoId()
            )
            
            // Check execution budgets
            for (_, budget) in evaluation.result {
                if budget.cpu > 10_000_000 { // Example limit
                    issues.append(.highCpuUsage(budget.cpu))
                }
                if budget.memory > 14_000_000 { // Example limit
                    issues.append(.highMemoryUsage(budget.memory))
                }
            }
            
        } catch {
            issues.append(.evaluationFailed(error.localizedDescription))
        }
        
        // 2. Check transaction size
        if transaction.count > 16_384 { // 16KB limit example
            issues.append(.transactionTooLarge(transaction.count))
        }
        
        // 3. Get protocol parameters and validate fee
        do {
            let protocolParams = try await client.ledgerStateQuery.protocolParameters.execute()
            let minFee = calculateMinimumFee(for: transaction, using: protocolParams.result)
            
            // Extract actual fee from transaction (implementation depends on transaction format)
            let actualFee = extractFee(from: transaction)
            
            if actualFee < minFee {
                issues.append(.feeTooLow(required: minFee, provided: actualFee))
            }
            
        } catch {
            issues.append(.parameterCheckFailed(error.localizedDescription))
        }
        
        return ValidationResult(issues: issues, isValid: issues.isEmpty)
    }
    
    private func calculateMinimumFee(for transaction: Data, using params: ProtocolParameters) -> UInt64 {
        // Implement fee calculation based on protocol parameters
        // This is a simplified calculation - use proper fee calculation library
        let baseFee = params.minFeeConstant
        let sizeFee = UInt64(transaction.count) * params.minFeeCoefficient
        return baseFee + sizeFee
    }
    
    private func extractFee(from transaction: Data) -> UInt64 {
        // Extract fee from transaction CBOR
        // Implementation depends on transaction format
        return 0 // Placeholder
    }
}

struct ValidationResult {
    let issues: [ValidationIssue]
    let isValid: Bool
}

enum ValidationIssue {
    case highCpuUsage(UInt64)
    case highMemoryUsage(UInt64)
    case transactionTooLarge(Int)
    case feeTooLow(required: UInt64, provided: UInt64)
    case evaluationFailed(String)
    case parameterCheckFailed(String)
    
    var description: String {
        switch self {
        case .highCpuUsage(let cpu):
            return "High CPU usage: \(cpu) steps"
        case .highMemoryUsage(let memory):
            return "High memory usage: \(memory) units"
        case .transactionTooLarge(let size):
            return "Transaction too large: \(size) bytes"
        case .feeTooLow(let required, let provided):
            return "Fee too low: \(provided) (required: \(required))"
        case .evaluationFailed(let error):
            return "Evaluation failed: \(error)"
        case .parameterCheckFailed(let error):
            return "Parameter check failed: \(error)"
        }
    }
}
```

## Complete Transaction Workflow

### Production-Ready Transaction Service

```swift path=null start=null
@MainActor
class ProductionTransactionService: ObservableObject {
    @Published var isSubmitting = false
    @Published var submissionStatus: SubmissionStatus = .idle
    @Published var lastTransactionId: String?
    @Published var confirmationCount = 0
    
    private let client: OgmiosClient
    private let validator: TransactionValidator
    private let submitter: ResilientTransactionSubmitter
    private let monitor: TransactionMonitor
    private let tracker: TransactionTracker
    
    enum SubmissionStatus {
        case idle
        case validating
        case submitting
        case waitingConfirmation
        case confirmed
        case failed(String)
        case rolledBack
    }
    
    init(client: OgmiosClient) {
        self.client = client
        self.validator = TransactionValidator(client: client)
        self.submitter = ResilientTransactionSubmitter(client: client)
        self.monitor = TransactionMonitor(client: client)
        self.tracker = TransactionTracker(client: client)
    }
    
    func submitTransaction(
        _ transaction: Data,
        requiredConfirmations: Int = 1
    ) async {
        isSubmitting = true
        submissionStatus = .validating
        
        defer {
            isSubmitting = false
        }
        
        do {
            // 1. Validate transaction
            let validation = try await validator.validateBeforeSubmission(transaction: transaction)
            
            if !validation.isValid {
                let issues = validation.issues.map { $0.description }.joined(separator: ", ")
                submissionStatus = .failed("Validation failed: \(issues)")
                return
            }
            
            // 2. Submit transaction
            submissionStatus = .submitting
            
            let transactionId = try await submitter.submitWithRetry(
                transaction: transaction
            ) { error, attempt in
                print("Submission attempt \(attempt) failed: \(error.localizedDescription)")
            }
            
            lastTransactionId = transactionId
            
            // 3. Track transaction
            await tracker.trackTransaction(transactionId)
            
            // 4. Wait for confirmation
            submissionStatus = .waitingConfirmation
            
            let confirmed = try await monitor.waitForConfirmation(
                transactionId: transactionId,
                requiredConfirmations: requiredConfirmations
            )
            
            if confirmed {
                submissionStatus = .confirmed
                confirmationCount = requiredConfirmations
            } else {
                submissionStatus = .failed("Confirmation timeout")
            }
            
        } catch let error as TransactionSubmissionError {
            submissionStatus = .failed(error.localizedDescription)
        } catch {
            submissionStatus = .failed("Unknown error: \(error.localizedDescription)")
        }
    }
    
    func checkTransactionStatus() async {
        guard let txId = lastTransactionId else { return }
        
        let status = await tracker.getStatus(for: txId)
        
        if let status = status {
            confirmationCount = status.confirmations
            
            if status.isRolledBack {
                submissionStatus = .rolledBack
            } else if status.confirmations > 0 {
                submissionStatus = .confirmed
            }
        }
    }
}
```

### SwiftUI Integration

```swift path=null start=null
struct TransactionSubmissionView: View {
    @StateObject private var transactionService: ProductionTransactionService
    @State private var transactionData = Data()
    @State private var showingDetails = false
    
    init(client: OgmiosClient) {
        self._transactionService = StateObject(wrappedValue: ProductionTransactionService(client: client))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Status indicator
            statusView
            
            // Transaction ID
            if let txId = transactionService.lastTransactionId {
                VStack {
                    Text("Transaction ID")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(txId)
                        .font(.system(.caption, design: .monospaced))
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }
            
            // Confirmation count
            if transactionService.confirmationCount > 0 {
                HStack {
                    Text("Confirmations:")
                    Text("\(transactionService.confirmationCount)")
                        .fontWeight(.semibold)
                }
                .font(.caption)
            }
            
            // Submit button
            Button("Submit Transaction") {
                Task {
                    await transactionService.submitTransaction(
                        transactionData,
                        requiredConfirmations: 3
                    )
                }
            }
            .disabled(transactionService.isSubmitting || transactionData.isEmpty)
            .buttonStyle(.borderedProminent)
            
            // Details button
            Button("View Details") {
                showingDetails = true
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .sheet(isPresented: $showingDetails) {
            TransactionDetailsView(service: transactionService)
        }
        .task {
            // Periodically check transaction status
            while !Task.isCancelled {
                await transactionService.checkTransactionStatus()
                try? await Task.sleep(nanoseconds: 30_000_000_000) // 30 seconds
            }
        }
    }
    
    @ViewBuilder
    private var statusView: some View {
        HStack {
            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
            
            Text(statusText)
                .font(.headline)
        }
    }
    
    private var statusColor: Color {
        switch transactionService.submissionStatus {
        case .idle:
            return .gray
        case .validating, .submitting, .waitingConfirmation:
            return .orange
        case .confirmed:
            return .green
        case .failed, .rolledBack:
            return .red
        }
    }
    
    private var statusText: String {
        switch transactionService.submissionStatus {
        case .idle:
            return "Ready"
        case .validating:
            return "Validating..."
        case .submitting:
            return "Submitting..."
        case .waitingConfirmation:
            return "Waiting for Confirmation"
        case .confirmed:
            return "Confirmed"
        case .failed(let error):
            return "Failed: \(error)"
        case .rolledBack:
            return "Rolled Back"
        }
    }
}
```

## Best Practices

1. **Always Validate Before Submitting**: Use transaction evaluation to catch issues early
2. **Handle Specific Errors**: Provide meaningful error messages and recovery suggestions
3. **Implement Retry Logic**: Use exponential backoff for retryable errors
4. **Monitor Confirmations**: Track transaction status through multiple confirmations
5. **Handle Rollbacks**: Be prepared for chain reorganizations
6. **Fee Management**: Calculate appropriate fees based on current protocol parameters
7. **User Feedback**: Provide clear status updates throughout the submission process
8. **Testing**: Test with different error scenarios and network conditions

## See Also

- <doc:GettingStarted> - Basic setup and first operations
- <doc:ErrorHandling> - Comprehensive error handling strategies
- <doc:LedgerStateQueries> - Querying protocol parameters and UTxOs
- <doc:ChainSynchronization> - Monitoring transaction confirmations
- <doc:MempoolMonitoring> - Tracking transactions in mempool