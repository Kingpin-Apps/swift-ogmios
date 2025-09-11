// MARK: - Supporting Types

/// Reference script fee structure
public struct MinFeeReferenceScripts: Codable, Sendable {
    public let range: UInt32
    public let base: Double
    public let multiplier: Double
    
    public init(range: UInt32, base: Double, multiplier: Double) {
        self.range = range
        self.base = base
        self.multiplier = multiplier
    }
}

/// Execution units for script execution
public struct ExecutionUnits: Codable, Sendable {
    public let memory: UInt64
    public let cpu: UInt64
    
    public init(memory: UInt64, cpu: UInt64) {
        self.memory = memory
        self.cpu = cpu
    }
}

/// Script execution pricing
public struct ScriptExecutionPrices: Codable, Sendable {
    public let memory: Ratio
    public let cpu: Ratio
    
    public init(memory: Ratio, cpu: Ratio) {
        self.memory = memory
        self.cpu = cpu
    }
}

/// Cost models for Plutus scripts
public struct CostModels: Codable, Sendable {
    // This would typically contain cost model parameters for different Plutus versions
    // The exact structure depends on the specific cost models used
    public let plutusV1: [String: Int]?
    public let plutusV2: [String: Int]?
    public let plutusV3: [String: Int]?
    
    public init(plutusV1: [String: Int]? = nil, plutusV2: [String: Int]? = nil, plutusV3: [String: Int]? = nil) {
        self.plutusV1 = plutusV1
        self.plutusV2 = plutusV2
        self.plutusV3 = plutusV3
    }
}

/// Stake pool voting thresholds
public struct StakePoolVotingThresholds: Codable, Sendable {
    public let noConfidence: Ratio
    public let constitutionalCommittee: ConstitutionalCommitteeThresholds
    public let hardForkInitiation: Ratio
    public let protocolParametersUpdate: ProtocolParametersUpdateThresholds
    
    public init(noConfidence: Ratio, constitutionalCommittee: ConstitutionalCommitteeThresholds, hardForkInitiation: Ratio, protocolParametersUpdate: ProtocolParametersUpdateThresholds) {
        self.noConfidence = noConfidence
        self.constitutionalCommittee = constitutionalCommittee
        self.hardForkInitiation = hardForkInitiation
        self.protocolParametersUpdate = protocolParametersUpdate
    }
}

/// Constitutional committee thresholds
public struct ConstitutionalCommitteeThresholds: Codable, Sendable {
    public let `default`: Ratio
    public let stateOfNoConfidence: Ratio
    
    public init(default: Ratio, stateOfNoConfidence: Ratio) {
        self.`default` = `default`
        self.stateOfNoConfidence = stateOfNoConfidence
    }
}

/// Protocol parameters update thresholds
public struct ProtocolParametersUpdateThresholds: Codable, Sendable {
    public let security: Ratio
    
    public init(security: Ratio) {
        self.security = security
    }
}

/// Delegate representative voting thresholds
public struct DelegateRepresentativeVotingThresholds: Codable, Sendable {
    public let noConfidence: Ratio
    public let constitutionalCommittee: ConstitutionalCommitteeThresholds
    public let updateConstitution: Ratio
    public let hardForkInitiation: Ratio
    public let protocolParametersUpdate: Ratio
    public let treasuryWithdrawal: Ratio
    
    public init(noConfidence: Ratio, constitutionalCommittee: ConstitutionalCommitteeThresholds, updateConstitution: Ratio, hardForkInitiation: Ratio, protocolParametersUpdate: Ratio, treasuryWithdrawal: Ratio) {
        self.noConfidence = noConfidence
        self.constitutionalCommittee = constitutionalCommittee
        self.updateConstitution = updateConstitution
        self.hardForkInitiation = hardForkInitiation
        self.protocolParametersUpdate = protocolParametersUpdate
        self.treasuryWithdrawal = treasuryWithdrawal
    }
}

/// Protocol version
public struct ProtocolVersion: Codable, Sendable {
    public let major: UInt32
    public let minor: UInt32
    public let patch: UInt32?
    
    public init(major: UInt32, minor: UInt32, patch: UInt32? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

/// Nonce for extra entropy
public typealias Nonce = String

// MARK: - Main Type

/// Proposed protocol parameters that can be updated through governance
public struct ProposedProtocolParameters: Codable, Sendable {
    
    // Fee parameters
    public let minFeeCoefficient: UInt64?
    public let minFeeConstant: ValueAdaOnly?
    public let minFeeReferenceScripts: MinFeeReferenceScripts?
    
    // UTxO parameters
    public let minUtxoDepositCoefficient: UInt64?
    public let minUtxoDepositConstant: ValueAdaOnly?
    
    // Block and transaction size limits
    public let maxBlockBodySize: NumberOfBytes?
    public let maxBlockHeaderSize: NumberOfBytes?
    public let maxTransactionSize: NumberOfBytes?
    public let maxReferenceScriptsSize: NumberOfBytes?
    public let maxValueSize: NumberOfBytes?
    
    // Randomness
    public let extraEntropy: Nonce?
    
    // Staking parameters
    public let stakeCredentialDeposit: ValueAdaOnly?
    public let stakePoolDeposit: ValueAdaOnly?
    public let stakePoolRetirementEpochBound: UInt64?
    public let stakePoolPledgeInfluence: Ratio?
    public let minStakePoolCost: ValueAdaOnly?
    public let desiredNumberOfStakePools: UInt64?
    
    // Economic parameters
    public let federatedBlockProductionRatio: Ratio?
    public let monetaryExpansion: Ratio?
    public let treasuryExpansion: Ratio?
    
    // Collateral parameters
    public let collateralPercentage: UInt64?
    public let maxCollateralInputs: UInt64?
    
    // Script execution parameters
    public let plutusCostModels: CostModels?
    public let scriptExecutionPrices: ScriptExecutionPrices?
    public let maxExecutionUnitsPerTransaction: ExecutionUnits?
    public let maxExecutionUnitsPerBlock: ExecutionUnits?
    
    // Governance parameters
    public let stakePoolVotingThresholds: StakePoolVotingThresholds?
    public let constitutionalCommitteeMinSize: UInt16?
    public let constitutionalCommitteeMaxTermLength: UInt64?
    public let governanceActionLifetime: Epoch?
    public let governanceActionDeposit: ValueAdaOnly?
    public let delegateRepresentativeVotingThresholds: DelegateRepresentativeVotingThresholds?
    public let delegateRepresentativeDeposit: ValueAdaOnly?
    public let delegateRepresentativeMaxIdleTime: Epoch?
    
    // Protocol version
    public let version: ProtocolVersion?
    
    public init(
        minFeeCoefficient: UInt64? = nil,
        minFeeConstant: ValueAdaOnly? = nil,
        minFeeReferenceScripts: MinFeeReferenceScripts? = nil,
        minUtxoDepositCoefficient: UInt64? = nil,
        minUtxoDepositConstant: ValueAdaOnly? = nil,
        maxBlockBodySize: NumberOfBytes? = nil,
        maxBlockHeaderSize: NumberOfBytes? = nil,
        maxTransactionSize: NumberOfBytes? = nil,
        maxReferenceScriptsSize: NumberOfBytes? = nil,
        maxValueSize: NumberOfBytes? = nil,
        extraEntropy: Nonce? = nil,
        stakeCredentialDeposit: ValueAdaOnly? = nil,
        stakePoolDeposit: ValueAdaOnly? = nil,
        stakePoolRetirementEpochBound: UInt64? = nil,
        stakePoolPledgeInfluence: Ratio? = nil,
        minStakePoolCost: ValueAdaOnly? = nil,
        desiredNumberOfStakePools: UInt64? = nil,
        federatedBlockProductionRatio: Ratio? = nil,
        monetaryExpansion: Ratio? = nil,
        treasuryExpansion: Ratio? = nil,
        collateralPercentage: UInt64? = nil,
        maxCollateralInputs: UInt64? = nil,
        plutusCostModels: CostModels? = nil,
        scriptExecutionPrices: ScriptExecutionPrices? = nil,
        maxExecutionUnitsPerTransaction: ExecutionUnits? = nil,
        maxExecutionUnitsPerBlock: ExecutionUnits? = nil,
        stakePoolVotingThresholds: StakePoolVotingThresholds? = nil,
        constitutionalCommitteeMinSize: UInt16? = nil,
        constitutionalCommitteeMaxTermLength: UInt64? = nil,
        governanceActionLifetime: Epoch? = nil,
        governanceActionDeposit: ValueAdaOnly? = nil,
        delegateRepresentativeVotingThresholds: DelegateRepresentativeVotingThresholds? = nil,
        delegateRepresentativeDeposit: ValueAdaOnly? = nil,
        delegateRepresentativeMaxIdleTime: Epoch? = nil,
        version: ProtocolVersion? = nil
    ) {
        self.minFeeCoefficient = minFeeCoefficient
        self.minFeeConstant = minFeeConstant
        self.minFeeReferenceScripts = minFeeReferenceScripts
        self.minUtxoDepositCoefficient = minUtxoDepositCoefficient
        self.minUtxoDepositConstant = minUtxoDepositConstant
        self.maxBlockBodySize = maxBlockBodySize
        self.maxBlockHeaderSize = maxBlockHeaderSize
        self.maxTransactionSize = maxTransactionSize
        self.maxReferenceScriptsSize = maxReferenceScriptsSize
        self.maxValueSize = maxValueSize
        self.extraEntropy = extraEntropy
        self.stakeCredentialDeposit = stakeCredentialDeposit
        self.stakePoolDeposit = stakePoolDeposit
        self.stakePoolRetirementEpochBound = stakePoolRetirementEpochBound
        self.stakePoolPledgeInfluence = stakePoolPledgeInfluence
        self.minStakePoolCost = minStakePoolCost
        self.desiredNumberOfStakePools = desiredNumberOfStakePools
        self.federatedBlockProductionRatio = federatedBlockProductionRatio
        self.monetaryExpansion = monetaryExpansion
        self.treasuryExpansion = treasuryExpansion
        self.collateralPercentage = collateralPercentage
        self.maxCollateralInputs = maxCollateralInputs
        self.plutusCostModels = plutusCostModels
        self.scriptExecutionPrices = scriptExecutionPrices
        self.maxExecutionUnitsPerTransaction = maxExecutionUnitsPerTransaction
        self.maxExecutionUnitsPerBlock = maxExecutionUnitsPerBlock
        self.stakePoolVotingThresholds = stakePoolVotingThresholds
        self.constitutionalCommitteeMinSize = constitutionalCommitteeMinSize
        self.constitutionalCommitteeMaxTermLength = constitutionalCommitteeMaxTermLength
        self.governanceActionLifetime = governanceActionLifetime
        self.governanceActionDeposit = governanceActionDeposit
        self.delegateRepresentativeVotingThresholds = delegateRepresentativeVotingThresholds
        self.delegateRepresentativeDeposit = delegateRepresentativeDeposit
        self.delegateRepresentativeMaxIdleTime = delegateRepresentativeMaxIdleTime
        self.version = version
    }
}
