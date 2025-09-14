import Foundation

// Example usage of the QueryNetworkGenesisConfiguration

/*
// Create client
let client = OgmiosClient(transport: .http("http://localhost:1337"))

// Query Byron genesis configuration 
let byronGenesis = try await client.networkQuery.genesisConfiguration.execute(
    params: QueryNetworkGenesisConfiguration.Params(era: .byron)
)

switch byronGenesis.result {
case .byron(let config):
    print("Byron Genesis - Network Magic: \(config.networkMagic)")
    print("Byron Genesis - Start Time: \(config.startTime)")
    print("Byron Genesis - Security Parameter: \(config.securityParameter)")
    
case .shelley(let config):
    print("Shelley Genesis - Network Magic: \(config.networkMagic)")
    print("Shelley Genesis - Network: \(config.network)")
    print("Shelley Genesis - Epoch Length: \(config.epochLength)")
    
case .alonzo(let config):
    print("Alonzo Genesis - Min UTXO Deposit: \(config.updatableParameters.minUtxoDepositCoefficient)")
    print("Alonzo Genesis - Collateral %: \(config.updatableParameters.collateralPercentage)")
    
case .conway(let config):
    print("Conway Genesis - Governance Action Lifetime: \(config.updatableParameters.governanceActionLifetime)")
    
case .invalidGenesis(let error):
    print("Error: \(error.error?.message ?? "Unknown error")")
}

// Or query different eras:
// let shelleyGenesis = try await client.networkQuery.genesisConfiguration.execute(
//     params: QueryNetworkGenesisConfiguration.Params(era: .shelley)
// )
// let alonzoGenesis = try await client.networkQuery.genesisConfiguration.execute(
//     params: QueryNetworkGenesisConfiguration.Params(era: .alonzo)
// )
// let conwayGenesis = try await client.networkQuery.genesisConfiguration.execute(
//     params: QueryNetworkGenesisConfiguration.Params(era: .conway)
// )
*/