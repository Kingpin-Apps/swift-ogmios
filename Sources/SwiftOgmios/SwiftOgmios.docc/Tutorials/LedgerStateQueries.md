# Ledger State Queries

Master all available ledger state queries to extract detailed information about the Cardano blockchain state.

## Overview

Ledger state queries allow you to retrieve the current state of the Cardano ledger, including information about epochs, UTxOs, stake pools, governance, and protocol parameters. SwiftOgmios provides type-safe access to all 22 ledger state queries supported by Ogmios.

This comprehensive guide covers every available query with practical examples, parameter explanations, and performance considerations.

## Basic Query Pattern

All ledger state queries follow a consistent pattern:

```swift path=null start=null
import SwiftOgmios

// Basic query without parameters
let response = try await client.ledgerStateQuery.epoch.execute()
print("Current epoch: \(response.result)")

// Query with parameters and custom ID
let utxoResponse = try await client.ledgerStateQuery.utxo.execute(
    addresses: [Address("addr1...")],
    id: .generateNextNanoId()
)
```

## Era and Time Queries

### Current Epoch

Get the current epoch number:

```swift path=null start=null
let epochResponse = try await client.ledgerStateQuery.epoch.execute()
let currentEpoch: Int = epochResponse.result

print("Current epoch: \(currentEpoch)")
// Output: Current epoch: 425
```

**Use Cases**: Epoch-based calculations, reward distribution timing, protocol parameter change scheduling.

### Era Start

Query when the current era started:

```swift path=null start=null
let eraStartResponse = try await client.ledgerStateQuery.eraStart.execute()
let startPoint = eraStartResponse.result

print("Era started at slot: \(startPoint.slot)")
print("Era started at epoch: \(startPoint.epoch)")
```

**Use Cases**: Era transition analysis, historical data correlation.

### Era Summaries

Get comprehensive information about all blockchain eras:

```swift path=null start=null
let eraSummariesResponse = try await client.ledgerStateQuery.eraSummaries.execute()

for era in eraSummariesResponse.result {
    let endDescription = era.end?.epoch.map { String($0) } ?? "ongoing"
    print("Era: \(era.start.epoch) to \(endDescription)")
    print("  Parameters: \(era.parameters)")
}
```

**Use Cases**: Historical analysis, era transition planning, protocol evolution tracking.

## Network State Queries

### Ledger Tip

Query the current tip of the ledger:

```swift path=null start=null
let tipResponse = try await client.ledgerStateQuery.tip.execute()
let tip = tipResponse.result

print("Ledger tip:")
print("  Slot: \(tip.slot)")
print("  Block ID: \(tip.id)")
print("  Height: \(tip.height)")
```

**Use Cases**: Synchronization status, latest block information, chain progress tracking.

### Protocol Parameters

Access current protocol parameters:

```swift path=null start=null
let paramsResponse = try await client.ledgerStateQuery.protocolParameters.execute()
let params = paramsResponse.result

print("Protocol parameters:")
print("  Min fee A: \(params.minFeeCoefficient)")
print("  Min fee B: \(params.minFeeConstant)")
print("  Max block size: \(params.maxBlockHeaderSize)")
print("  Max transaction size: \(params.maxTransactionSize)")
```

**Use Cases**: Fee calculation, transaction size validation, smart contract development.

### Proposed Protocol Parameters

Check for pending protocol parameter updates:

```swift path=null start=null
do {
    let proposedResponse = try await client.ledgerStateQuery.proposedProtocolParameters.execute()
    let proposedParams = proposedResponse.result
    
    if let params = proposedParams {
        print("Proposed parameter changes detected")
        // Process proposed changes
    } else {
        print("No proposed parameter changes")
    }
} catch {
    print("Error querying proposed parameters: \(error)")
}
```

**Performance Tip**: Cache protocol parameters and only refresh when epoch changes, as they typically remain stable.

## UTxO and Transaction Queries

### UTxO Query

Query UTxOs by various criteria:

#### Query Entire UTxO Set

```swift path=null start=null
let allUtxoResponse = try await client.ledgerStateQuery.utxo.execute(
    wholeUtxo: true,
    id: .generateNextNanoId()
)

print("Total UTxOs: \(allUtxoResponse.result.count)")
for utxo in allUtxoResponse.result.prefix(5) { // Show first 5
    print("UTxO: \(utxo.transaction.id)#\(utxo.index)")
    print("  Value: \(utxo.value.ada.lovelace) lovelace")
}
```

**⚠️ Warning**: Querying the entire UTxO set returns large amounts of data. Use with caution.

#### Query UTxOs by Addresses

```swift path=null start=null
let addresses = [
    Address("addr1qx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3jcu5d8ps7zex2k2xt3uqxgjqnnj83ws8lhrn648jjxtwq2ytjqp"),
    Address("addr1q8v42wjda8r6mpfj40d36znlgfdcqp7jtj03ah8skh6u8wnrqua2vw243tmjfjt0h5wsru6appuz8c0pfd75ur7myyeqsx9990")
]

let addressUtxoResponse = try await client.ledgerStateQuery.utxo.execute(
    addresses: addresses,
    id: .generateNextNanoId()
)

for utxo in addressUtxoResponse.result {
    print("Address: \(utxo.address.value)")
    print("Value: \(utxo.value.ada.lovelace) lovelace")
    
    // Check for native assets
    if let assets = utxo.value.assets {
        for (policyId, tokens) in assets {
            for (assetName, quantity) in tokens {
                print("Asset: \(policyId).\(assetName) = \(quantity)")
            }
        }
    }
}
```

#### Query UTxOs by Transaction Outputs

```swift path=null start=null
let outputReferences = [
    TransactionOutputReference(
        transaction: TransactionOutputReference.TransactionReference(
            id: "1234567890abcdef..."
        ),
        index: 0
    )
]

let refUtxoResponse = try await client.ledgerStateQuery.utxo.execute(
    outputReferences: outputReferences,
    id: .generateNextNanoId()
)
```

**Use Cases**: Wallet balance checking, transaction input validation, asset tracking.

**Performance Tips**: 
- Query by specific addresses rather than the entire UTxO set
- Batch multiple addresses in a single query
- Cache results and refresh periodically

## Stake Pool Queries

### Live Stake Distribution

Get current stake distribution across all pools:

```swift path=null start=null
let stakeResponse = try await client.ledgerStateQuery.liveStakeDistribution.execute()
let distribution = stakeResponse.result

print("Stake distribution across \(distribution.value.count) pools")

// Find top 10 pools by stake
let sortedPools = distribution.value.sorted { $0.value.stake > $1.value.stake }
for (index, (poolId, poolInfo)) in sortedPools.prefix(10).enumerated() {
    let stakeAda = Double(poolInfo.stake) / 1_000_000 // Convert to ADA
    print("\(index + 1). Pool \(poolId.value.prefix(8))...: \(String(format: "%.2f", stakeAda)) ADA")
}
```

### Stake Pools

Get detailed information about all registered stake pools:

```swift path=null start=null
let poolsResponse = try await client.ledgerStateQuery.stakePools.execute()
let pools = poolsResponse.result

print("Total registered pools: \(pools.count)")

for (poolId, pool) in pools.prefix(3) { // Show first 3 pools
    print("\nPool ID: \(poolId.value)")
    print("Cost: \(pool.cost) lovelace")
    print("Margin: \(pool.margin)")
    print("Pledge: \(pool.pledge) lovelace")
    
    if let metadata = pool.metadata {
        print("Metadata URL: \(metadata.url)")
        print("Metadata Hash: \(metadata.hash)")
    }
}
```

### Stake Pool Performances

Query performance metrics for stake pools:

```swift path=null start=null
let performanceResponse = try await client.ledgerStateQuery.stakePoolsPerformances.execute()
let performances = performanceResponse.result

for (poolId, performance) in performances.prefix(5) {
    print("Pool \(poolId.value.prefix(8))...: \(performance)")
}
```

### Operational Certificates

Get operational certificate information:

```swift path=null start=null
let certResponse = try await client.ledgerStateQuery.operationalCertificates.execute()
let certificates = certResponse.result

print("Operational certificates: \(certificates.count)")
```

**Use Cases**: Pool delegation decisions, performance analysis, pool operator monitoring.

## Governance Queries (Conway Era)

### Constitution

Query the current constitution (Conway era):

```swift path=null start=null
let constitutionResponse = try await client.ledgerStateQuery.constitution.execute()

if let constitution = constitutionResponse.result {
    print("Constitution found:")
    if let anchor = constitution.anchor {
        print("  URL: \(anchor.url)")
        print("  Hash: \(anchor.dataHash)")
    }
    
    if let script = constitution.guardrails {
        print("  Guardrails script: \(script)")
    }
} else {
    print("No constitution defined")
}
```

### Constitutional Committee

Query constitutional committee state:

```swift path=null start=null
let committeeResponse = try await client.ledgerStateQuery.constitutionalCommittee.execute()

if let committee = committeeResponse.result {
    print("Constitutional Committee:")
    print("  Threshold: \(committee.threshold)")
    print("  Members: \(committee.members.count)")
    
    for (keyHash, epoch) in committee.members {
        print("    Member \(keyHash): expires epoch \(epoch)")
    }
} else {
    print("No constitutional committee")
}
```

### Governance Proposals

Query active governance proposals:

```swift path=null start=null
let proposalsResponse = try await client.ledgerStateQuery.governanceProposals.execute()

print("Active proposals: \(proposalsResponse.result.count)")

for proposal in proposalsResponse.result.prefix(3) {
    print("\nProposal ID: \(proposal.proposal.transaction.id)")
    print("Index: \(proposal.proposal.index)")
    print("Deposit: \(proposal.deposit) lovelace")
    print("Return address: \(proposal.returnAddress.value)")
}
```

### Delegate Representatives (DReps)

Query registered delegate representatives:

```swift path=null start=null
let drepsResponse = try await client.ledgerStateQuery.delegateRepresentatives.execute()

print("Registered DReps: \(drepsResponse.result.count)")

for drep in drepsResponse.result.prefix(5) {
    print("\nDRep: \(drep.id)")
    print("Type: \(drep.type)")
    
    if let anchor = drep.anchor {
        print("Metadata: \(anchor.url)")
    }
}
```

**Use Cases**: Governance participation, voting decisions, proposal tracking.

## Rewards and Economics

### Treasury and Reserves

Query treasury and reserves amounts:

```swift path=null start=null
let treasuryResponse = try await client.ledgerStateQuery.treasuryAndReserves.execute()
let treasury = treasuryResponse.result

let treasuryAda = Double(treasury.treasury.ada.lovelace) / 1_000_000
let reservesAda = Double(treasury.reserves.ada.lovelace) / 1_000_000

print("Treasury: \(String(format: "%.2f", treasuryAda)) ADA")
print("Reserves: \(String(format: "%.2f", reservesAda)) ADA")
```

### Projected Rewards

Query projected rewards for stake pools:

```swift path=null start=null
let rewardsResponse = try await client.ledgerStateQuery.projectedRewards.execute()
let rewards = rewardsResponse.result

for (stakeCredential, reward) in rewards.prefix(5) {
    let rewardAda = Double(reward) / 1_000_000
    print("Stake credential \(stakeCredential): \(String(format: "%.6f", rewardAda)) ADA")
}
```

### Reward Account Summaries

Query reward account information:

```swift path=null start=null
let accountsResponse = try await client.ledgerStateQuery.rewardAccountSummaries.execute()
let accounts = accountsResponse.result

for (rewardAccount, summary) in accounts.prefix(3) {
    print("\nReward account: \(rewardAccount)")
    print("Available rewards: \(summary.rewards) lovelace")
    
    if let delegation = summary.delegation {
        print("Delegated to: \(delegation)")
    }
}
```

**Use Cases**: Reward calculation, delegation analysis, economic modeling.

## Advanced Queries

### Ledger State Dump

Export complete ledger state (use with caution):

```swift path=null start=null
let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
    .appendingPathComponent("ledger-dump-\(Date().timeIntervalSince1970)")
    .appendingPathExtension("json")

do {
    let dumpResponse = try await client.ledgerStateQuery.dump.execute(
        to: tempURL.path,
        id: .generateNextNanoId()
    )
    
    print("Ledger state dumped to: \(tempURL.path)")
    print("Dump result: \(dumpResponse.result)")
    
    // Process the dump file
    if FileManager.default.fileExists(atPath: tempURL.path) {
        let fileSize = try FileManager.default.attributesOfItem(atPath: tempURL.path)[.size] as! Int64
        print("Dump file size: \(fileSize) bytes")
    }
    
} catch {
    print("Failed to dump ledger state: \(error)")
}
```

**⚠️ Warning**: Ledger state dumps can be very large (several GB). Use only for debugging or analysis purposes.

### Nonces

Query consensus nonces for randomness:

```swift path=null start=null
let noncesResponse = try await client.ledgerStateQuery.nonces.execute()
let nonces = noncesResponse.result

print("Epoch nonce: \(nonces.epochNonce)")
print("Extra entropy: \(nonces.extraEntropy)")
```

**Use Cases**: Randomness verification, consensus debugging.

## Error Handling and Best Practices

### Robust Error Handling

```swift path=null start=null
func queryWithRetry<T>(
    query: () async throws -> T,
    maxRetries: Int = 3
) async throws -> T {
    var lastError: Error?
    
    for attempt in 1...maxRetries {
        do {
            return try await query()
        } catch OgmiosError.responseError(let message) {
            if message.contains("2001") { // Era mismatch
                print("Era mismatch - query not available in current era")
                throw OgmiosError.responseError("Query not available in current era")
            } else if message.contains("2002") { // Unavailable in current era
                print("Query unavailable in current era")
                throw OgmiosError.responseError("Query unavailable in current era")
            } else if attempt < maxRetries {
                print("Attempt \(attempt) failed, retrying...")
                lastError = OgmiosError.responseError(message)
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            } else {
                throw OgmiosError.responseError(message)
            }
        } catch {
            throw error
        }
    }
    
    throw lastError ?? OgmiosError.responseError("Max retries exceeded")
}

// Usage
do {
    let epoch = try await queryWithRetry {
        return try await client.ledgerStateQuery.epoch.execute()
    }
    print("Current epoch: \(epoch.result)")
} catch {
    print("Failed to query epoch: \(error)")
}
```

### Performance Optimization

#### Batch Queries

```swift path=null start=null
// Execute multiple queries concurrently
async func fetchDashboardData() async throws -> (epoch: Int, tip: Point, pools: Int) {
    async let epochTask = client.ledgerStateQuery.epoch.execute()
    async let tipTask = client.ledgerStateQuery.tip.execute()
    async let poolsTask = client.ledgerStateQuery.stakePools.execute()
    
    let (epochResponse, tipResponse, poolsResponse) = try await (epochTask, tipTask, poolsTask)
    
    return (
        epoch: epochResponse.result,
        tip: tipResponse.result,
        pools: poolsResponse.result.count
    )
}

// Usage
do {
    let dashboard = try await fetchDashboardData()
    print("Epoch: \(dashboard.epoch)")
    print("Tip: \(dashboard.tip.slot)")
    print("Pools: \(dashboard.pools)")
} catch {
    print("Dashboard fetch failed: \(error)")
}
```

#### Caching Strategy

```swift path=null start=null
@MainActor
class LedgerStateCache: ObservableObject {
    @Published var currentEpoch: Int?
    @Published var protocolParams: ProtocolParameters?
    @Published var lastUpdated: Date?
    
    private let client: OgmiosClient
    private let cacheTimeout: TimeInterval = 300 // 5 minutes
    
    init(client: OgmiosClient) {
        self.client = client
    }
    
    func getProtocolParameters() async throws -> ProtocolParameters {
        if let params = protocolParams,
           let lastUpdated = lastUpdated,
           Date().timeIntervalSince(lastUpdated) < cacheTimeout {
            return params
        }
        
        let response = try await client.ledgerStateQuery.protocolParameters.execute()
        
        await MainActor.run {
            self.protocolParams = response.result
            self.lastUpdated = Date()
        }
        
        return response.result
    }
    
    func getCurrentEpoch() async throws -> Int {
        if let epoch = currentEpoch,
           let lastUpdated = lastUpdated,
           Date().timeIntervalSince(lastUpdated) < cacheTimeout {
            return epoch
        }
        
        let response = try await client.ledgerStateQuery.epoch.execute()
        
        await MainActor.run {
            self.currentEpoch = response.result
            self.lastUpdated = Date()
        }
        
        return response.result
    }
}
```

## Query Compatibility by Era

Different queries are available in different Cardano eras:

| Query | Byron | Shelley | Alonzo | Babbage | Conway |
|-------|-------|---------|---------|---------|---------|
| `epoch` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `tip` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `stakePools` | ❌ | ✅ | ✅ | ✅ | ✅ |
| `constitution` | ❌ | ❌ | ❌ | ❌ | ✅ |
| `governanceProposals` | ❌ | ❌ | ❌ | ❌ | ✅ |

Always handle era-specific errors in your queries.

## See Also

- <doc:GettingStarted> - Basic setup and first queries
- <doc:ErrorHandling> - Comprehensive error handling strategies
- <doc:TransportTypes> - Optimizing query performance with transport selection
- <doc:AdvancedUsage> - Advanced query patterns and optimization techniques