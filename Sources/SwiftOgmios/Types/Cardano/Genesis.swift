import Foundation
// MARK: - Genesis Configurations

/// Byron genesis configuration, with information used to bootstrap the era.
public struct GenesisConfigurationByron: JSONSerializable {
    public let era: String
    public let genesisKeyHashes: [String] // Digest<Blake2b, 224>
    public let genesisDelegations: [String: BootstrapOperationalCertificate]
    public let startTime: String // UTC time string  
    public let initialFunds: [String: ValueAdaOnly] // Address -> Value<AdaOnly>
    public let initialVouchers: [String: ValueAdaOnly] // VerificationKey -> Value<AdaOnly>
    public let securityParameter: UInt64
    public let networkMagic: NetworkMagic
    public let updatableParameters: ByronProtocolParameters?
    
    // Custom date property for parsed startTime
    public var startTimeDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: startTime)
    }
    
    public init(era: String = "byron", genesisKeyHashes: [String], genesisDelegations: [String: BootstrapOperationalCertificate], startTime: String, initialFunds: [String: ValueAdaOnly], initialVouchers: [String: ValueAdaOnly], securityParameter: UInt64, networkMagic: NetworkMagic, updatableParameters: ByronProtocolParameters? = nil) {
        self.era = era
        self.genesisKeyHashes = genesisKeyHashes
        self.genesisDelegations = genesisDelegations
        self.startTime = startTime
        self.initialFunds = initialFunds
        self.initialVouchers = initialVouchers
        self.securityParameter = securityParameter
        self.networkMagic = networkMagic
        self.updatableParameters = updatableParameters
    }
}

/// Shelley genesis configuration, with information used to bootstrap the era.
public struct GenesisConfigurationShelley: JSONSerializable {
    public let era: String
    public let startTime: String // UTC time string
    public let networkMagic: NetworkMagic
    public let network: Network
    public let activeSlotsCoefficient: String // Ratio as string like "1/20"
    public let securityParameter: UInt64
    public let epochLength: UInt64 // Epoch as UInt64
    public let slotsPerKesPeriod: UInt64
    public let maxKesEvolutions: UInt64
    public let slotLength: SlotLength
    public let updateQuorum: UInt64
    public let maxLovelaceSupply: UInt64
    public let initialParameters: ProtocolParameters
    public let initialDelegates: [InitialDelegate]
    public let initialFunds: [String: ValueAdaOnly] // Address -> Value<AdaOnly>
    public let initialStakePools: GenesisStakePools
    
    // Custom date property for parsed startTime
    public var startTimeDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: startTime)
    }
    
    public init(era: String = "shelley", startTime: String, networkMagic: NetworkMagic, network: Network, activeSlotsCoefficient: String, securityParameter: UInt64, epochLength: UInt64, slotsPerKesPeriod: UInt64, maxKesEvolutions: UInt64, slotLength: SlotLength, updateQuorum: UInt64, maxLovelaceSupply: UInt64, initialParameters: ProtocolParameters, initialDelegates: [InitialDelegate], initialFunds: [String: ValueAdaOnly], initialStakePools: GenesisStakePools) {
        self.era = era
        self.startTime = startTime
        self.networkMagic = networkMagic
        self.network = network
        self.activeSlotsCoefficient = activeSlotsCoefficient
        self.securityParameter = securityParameter
        self.epochLength = epochLength
        self.slotsPerKesPeriod = slotsPerKesPeriod
        self.maxKesEvolutions = maxKesEvolutions
        self.slotLength = slotLength
        self.updateQuorum = updateQuorum
        self.maxLovelaceSupply = maxLovelaceSupply
        self.initialParameters = initialParameters
        self.initialDelegates = initialDelegates
        self.initialFunds = initialFunds
        self.initialStakePools = initialStakePools
    }
}

/// Alonzo genesis configuration, with information used to bootstrap the era.
public struct GenesisConfigurationAlonzo: JSONSerializable {
    public let era: String
    public let updatableParameters: AlonzoUpdatableParameters
    
    public init(era: String = "alonzo", updatableParameters: AlonzoUpdatableParameters) {
        self.era = era
        self.updatableParameters = updatableParameters
    }
}

/// Conway genesis configuration, with information used to bootstrap the era.
public struct GenesisConfigurationConway: JSONSerializable {
    public let era: String
    public let constitution: Constitution
    public let constitutionalCommittee: ConstitutionalCommitteeGenesis
    public let updatableParameters: ConwayUpdatableParameters
    
    public init(era: String = "conway", constitution: Constitution, constitutionalCommittee: ConstitutionalCommitteeGenesis, updatableParameters: ConwayUpdatableParameters) {
        self.era = era
        self.constitution = constitution
        self.constitutionalCommittee = constitutionalCommittee
        self.updatableParameters = updatableParameters
    }
}

// MARK: - Supporting Types

/// Bootstrap operational certificate for Byron era
public struct BootstrapOperationalCertificate: JSONSerializable {
    public let issuer: VerificationKeyWrapper
    public let delegate: VerificationKeyWrapper
}

/// Verification key wrapper
public struct VerificationKeyWrapper: JSONSerializable {
    public let verificationKey: String
}

/// Initial delegate in Shelley genesis
public struct InitialDelegate: JSONSerializable {
    public let issuer: IdWrapper
    public let delegate: DelegateInfo
}

/// ID wrapper
public struct IdWrapper: JSONSerializable {
    public let id: String
}

/// Delegate information
public struct DelegateInfo: JSONSerializable {
    public let id: String
    public let vrfVerificationKeyHash: String
}

/// Genesis stake pools configuration
public struct GenesisStakePools: JSONSerializable {
    public let stakePools: [String: String] // Empty in test data
    public let delegators: [String: String] // Empty in test data
}

/// Byron protocol parameters
public struct ByronProtocolParameters: JSONSerializable {
    // Byron-specific parameters - for now keeping it flexible
    // The actual JSON response has many Byron-specific fields
}


/// Alonzo updatable parameters
public struct AlonzoUpdatableParameters: JSONSerializable {
    public let minUtxoDepositCoefficient: UInt64
    public let collateralPercentage: UInt64
    public let plutusCostModels: [String: [Int]] // Cost models as dictionary
    public let maxCollateralInputs: UInt64
    public let maxExecutionUnitsPerBlock: SwiftOgmios.ExecutionUnits
    public let maxExecutionUnitsPerTransaction: SwiftOgmios.ExecutionUnits
    public let maxValueSize: NumberOfBytes // As structured object
    public let scriptExecutionPrices: SwiftOgmios.ScriptExecutionPrices
}

/// Constitutional committee genesis configuration
public struct ConstitutionalCommitteeGenesis: JSONSerializable {
    public let members: [ConstitutionalCommitteeMemberSummary]
    public let quorum: Ratio
}

/// Conway updatable parameters
public struct ConwayUpdatableParameters: JSONSerializable {
    public let stakePoolVotingThresholds: SwiftOgmios.StakePoolVotingThresholds
    public let constitutionalCommitteeMinSize: UInt64
    public let constitutionalCommitteeMaxTermLength: UInt64
    public let governanceActionLifetime: UInt64
    public let governanceActionDeposit: ValueAdaOnly // As ADA value object
    public let delegateRepresentativeVotingThresholds: SwiftOgmios.DelegateRepresentativeVotingThresholds
    public let delegateRepresentativeDeposit: ValueAdaOnly // As ADA value object
    public let delegateRepresentativeMaxIdleTime: UInt64
}

// MARK: - Missing Type Aliases for Genesis-specific contexts
// Using fully qualified names to disambiguate from governance types

public typealias GenesisCostModels = SwiftOgmios.CostModels
public typealias GenesisExecutionUnits = SwiftOgmios.ExecutionUnits 
public typealias GenesisScriptExecutionPrices = SwiftOgmios.ScriptExecutionPrices
public typealias GenesisStakePoolVotingThresholds = SwiftOgmios.StakePoolVotingThresholds
public typealias GenesisDelegateRepresentativeVotingThresholds = SwiftOgmios.DelegateRepresentativeVotingThresholds

// MARK: - Network Types

/// Network magic number for telling networks apart
public typealias NetworkMagic = UInt32

/// Network target (mainnet or testnet)
public enum Network: String, JSONSerializable {
    case mainnet
    case testnet
}
