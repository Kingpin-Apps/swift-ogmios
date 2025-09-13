//
//  ProtocolParameters.swift
//  SwiftOgmios
//
//  Created by Hareem Adderley on 12/09/2025.
//

import Foundation

/// Current protocol parameters as returned by Ogmios queries
/// These represent the active protocol parameters for the current epoch
public struct ProtocolParameters: Codable, Sendable {
    
    // MARK: - Fee Parameters (Required)
    
    /// Minimum fee coefficient (linear factor)
    public let minFeeCoefficient: UInt64
    
    /// Minimum fee constant (base fee)
    public let minFeeConstant: ValueAdaOnly
    
    /// Fee structure for reference scripts
    public let minFeeReferenceScripts: MinFeeReferenceScripts?
    
    // MARK: - UTxO Parameters (Required)
    
    /// Minimum UTxO deposit coefficient
    public let minUtxoDepositCoefficient: UInt64
    
    /// Minimum UTxO deposit constant
    public let minUtxoDepositConstant: ValueAdaOnly
    
    // MARK: - Block and Transaction Size Limits
    
    /// Maximum block body size in bytes (Required)
    public let maxBlockBodySize: NumberOfBytes
    
    /// Maximum block header size in bytes (Required)
    public let maxBlockHeaderSize: NumberOfBytes
    
    /// Maximum transaction size in bytes
    public let maxTransactionSize: NumberOfBytes?
    
    /// Maximum size of reference scripts in bytes
    public let maxReferenceScriptsSize: NumberOfBytes?
    
    /// Maximum value size in bytes
    public let maxValueSize: NumberOfBytes?
    
    // MARK: - Randomness
    
    /// Extra entropy nonce
    public let extraEntropy: Nonce?
    
    // MARK: - Staking Parameters (Required)
    
    /// Deposit required for stake credential registration
    public let stakeCredentialDeposit: ValueAdaOnly
    
    /// Deposit required for stake pool registration
    public let stakePoolDeposit: ValueAdaOnly
    
    /// Maximum number of epochs before a stake pool retirement takes effect
    public let stakePoolRetirementEpochBound: UInt64
    
    /// Influence of stake pool pledge on rewards (a0 parameter)
    public let stakePoolPledgeInfluence: Ratio
    
    /// Minimum cost for stake pool operation per epoch
    public let minStakePoolCost: ValueAdaOnly
    
    /// Target number of stake pools (k parameter)
    public let desiredNumberOfStakePools: UInt64
    
    // MARK: - Economic Parameters
    
    /// Ratio of federated block production (Optional)
    public let federatedBlockProductionRatio: Ratio?
    
    /// Monetary expansion rate (rho parameter) (Required)
    public let monetaryExpansion: Ratio
    
    /// Treasury expansion rate (tau parameter) (Required)
    public let treasuryExpansion: Ratio
    
    // MARK: - Collateral Parameters
    
    /// Percentage of transaction fee that must be provided as collateral
    public let collateralPercentage: UInt64?
    
    /// Maximum number of collateral inputs allowed in a transaction
    public let maxCollateralInputs: UInt64?
    
    // MARK: - Script Execution Parameters
    
    /// Cost models for Plutus script execution
    public let plutusCostModels: CostModels?
    
    /// Prices for script execution units
    public let scriptExecutionPrices: ScriptExecutionPrices?
    
    /// Maximum execution units allowed per transaction
    public let maxExecutionUnitsPerTransaction: ExecutionUnits?
    
    /// Maximum execution units allowed per block
    public let maxExecutionUnitsPerBlock: ExecutionUnits?
    
    // MARK: - Governance Parameters (Conway Era) (Optional)
    
    /// Voting thresholds for stake pool operators
    public let stakePoolVotingThresholds: StakePoolVotingThresholds?
    
    /// Minimum size of constitutional committee
    public let constitutionalCommitteeMinSize: UInt64?
    
    /// Maximum term length for constitutional committee members
    public let constitutionalCommitteeMaxTermLength: UInt64?
    
    /// Lifetime of governance actions in epochs
    public let governanceActionLifetime: Epoch?
    
    /// Deposit required for submitting governance actions
    public let governanceActionDeposit: ValueAdaOnly?
    
    /// Voting thresholds for delegate representatives (DReps)
    public let delegateRepresentativeVotingThresholds: DelegateRepresentativeVotingThresholds?
    
    /// Deposit required for DRep registration
    public let delegateRepresentativeDeposit: ValueAdaOnly?
    
    /// Maximum idle time for DReps before they become inactive
    public let delegateRepresentativeMaxIdleTime: Epoch?
    
    // MARK: - Protocol Version (Required)
    
    /// Current protocol version
    public let version: ProtocolVersion
    
    // MARK: - Initialization
    
    public init(
        minFeeCoefficient: UInt64,
        minFeeConstant: ValueAdaOnly,
        minFeeReferenceScripts: MinFeeReferenceScripts? = nil,
        minUtxoDepositCoefficient: UInt64,
        minUtxoDepositConstant: ValueAdaOnly,
        maxBlockBodySize: NumberOfBytes,
        maxBlockHeaderSize: NumberOfBytes,
        maxTransactionSize: NumberOfBytes? = nil,
        maxReferenceScriptsSize: NumberOfBytes? = nil,
        maxValueSize: NumberOfBytes? = nil,
        extraEntropy: Nonce? = nil,
        stakeCredentialDeposit: ValueAdaOnly,
        stakePoolDeposit: ValueAdaOnly,
        stakePoolRetirementEpochBound: UInt64,
        stakePoolPledgeInfluence: Ratio,
        minStakePoolCost: ValueAdaOnly,
        desiredNumberOfStakePools: UInt64,
        federatedBlockProductionRatio: Ratio? = nil,
        monetaryExpansion: Ratio,
        treasuryExpansion: Ratio,
        collateralPercentage: UInt64? = nil,
        maxCollateralInputs: UInt64? = nil,
        plutusCostModels: CostModels? = nil,
        scriptExecutionPrices: ScriptExecutionPrices? = nil,
        maxExecutionUnitsPerTransaction: ExecutionUnits? = nil,
        maxExecutionUnitsPerBlock: ExecutionUnits? = nil,
        stakePoolVotingThresholds: StakePoolVotingThresholds? = nil,
        constitutionalCommitteeMinSize: UInt64? = nil,
        constitutionalCommitteeMaxTermLength: UInt64? = nil,
        governanceActionLifetime: Epoch? = nil,
        governanceActionDeposit: ValueAdaOnly? = nil,
        delegateRepresentativeVotingThresholds: DelegateRepresentativeVotingThresholds? = nil,
        delegateRepresentativeDeposit: ValueAdaOnly? = nil,
        delegateRepresentativeMaxIdleTime: Epoch? = nil,
        version: ProtocolVersion
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

