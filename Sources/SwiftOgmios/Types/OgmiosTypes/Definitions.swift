// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let definitions = try? newJSONDecoder().decode(Definitions.self, from: jsonData)

import Foundation

// MARK: - Definitions
public struct Definitions: Codable, Sendable {
    public let encodingBase16: EncodingBase16
    public let anyDelegateRepresentativeCredential, anyStakeCredential: AnyECredential
    public let deserialisationFailure: DeserialisationFailure
    public let eraMismatch: EraMismatch
    public let evaluateTransactionFailure: EvaluateTransactionFailure
    public let liveStakeDistribution: LiveStakeDistribution
    public let nonces: Nonces
    public let operationalCertificates: OperationalCertificates
    public let mempoolSizeAndCapacity: MempoolSizeAndCapacity
    public let pointOrOrigin: PointOrOrigin
    public let projectedRewards: ProjectedRewards
    public let rewardAccountSummary: RewardAccountSummary
    public let rewardsProvenance: RewardsProvenance
    public let stakePoolsPerformances: StakePoolsPerformances
    public let scriptExecutionFailure: ScriptExecutionFailure
    public let stakePoolSummary: StakePoolSummary
    public let submitTransactionFailure: SubmitTransactionFailure
    public let submitTransactionFailureExtraneousRedeemers: SubmitTransactionFailureExtraneousRedeemers
    public let submitTransactionFailureMissingDatums: SubmitTransactionFailureMissingDatums
    public let submitTransactionFailureUnknownOutputReference: SubmitTransactionFailureUnknownOutputReference
    public let submitTransactionFailureMissingCostModels: SubmitTransactionFailureMissingCostModels
    public let submitTransactionFailureExecutionBudgetOutOfBounds: SubmitTransactionFailureExecutionBudgetOutOfBounds
    public let tipOrOrigin: TipOrOrigin

    public enum CodingKeys: String, CodingKey {
        case encodingBase16 = "_encodingBase16"
        case anyDelegateRepresentativeCredential = "AnyDelegateRepresentativeCredential"
        case anyStakeCredential = "AnyStakeCredential"
        case deserialisationFailure = "DeserialisationFailure"
        case eraMismatch = "EraMismatch"
        case evaluateTransactionFailure = "EvaluateTransactionFailure"
        case liveStakeDistribution = "LiveStakeDistribution"
        case nonces = "Nonces"
        case operationalCertificates = "OperationalCertificates"
        case mempoolSizeAndCapacity = "MempoolSizeAndCapacity"
        case pointOrOrigin = "PointOrOrigin"
        case projectedRewards = "ProjectedRewards"
        case rewardAccountSummary = "RewardAccountSummary"
        case rewardsProvenance = "RewardsProvenance"
        case stakePoolsPerformances = "StakePoolsPerformances"
        case scriptExecutionFailure = "ScriptExecutionFailure"
        case stakePoolSummary = "StakePoolSummary"
        case submitTransactionFailure = "SubmitTransactionFailure"
        case submitTransactionFailureExtraneousRedeemers = "SubmitTransactionFailure<ExtraneousRedeemers>"
        case submitTransactionFailureMissingDatums = "SubmitTransactionFailure<MissingDatums>"
        case submitTransactionFailureUnknownOutputReference = "SubmitTransactionFailure<UnknownOutputReference>"
        case submitTransactionFailureMissingCostModels = "SubmitTransactionFailure<MissingCostModels>"
        case submitTransactionFailureExecutionBudgetOutOfBounds = "SubmitTransactionFailure<ExecutionBudgetOutOfBounds>"
        case tipOrOrigin = "TipOrOrigin"
    }

    public init(encodingBase16: EncodingBase16, anyDelegateRepresentativeCredential: AnyECredential, anyStakeCredential: AnyECredential, deserialisationFailure: DeserialisationFailure, eraMismatch: EraMismatch, evaluateTransactionFailure: EvaluateTransactionFailure, liveStakeDistribution: LiveStakeDistribution, nonces: Nonces, operationalCertificates: OperationalCertificates, mempoolSizeAndCapacity: MempoolSizeAndCapacity, pointOrOrigin: PointOrOrigin, projectedRewards: ProjectedRewards, rewardAccountSummary: RewardAccountSummary, rewardsProvenance: RewardsProvenance, stakePoolsPerformances: StakePoolsPerformances, scriptExecutionFailure: ScriptExecutionFailure, stakePoolSummary: StakePoolSummary, submitTransactionFailure: SubmitTransactionFailure, submitTransactionFailureExtraneousRedeemers: SubmitTransactionFailureExtraneousRedeemers, submitTransactionFailureMissingDatums: SubmitTransactionFailureMissingDatums, submitTransactionFailureUnknownOutputReference: SubmitTransactionFailureUnknownOutputReference, submitTransactionFailureMissingCostModels: SubmitTransactionFailureMissingCostModels, submitTransactionFailureExecutionBudgetOutOfBounds: SubmitTransactionFailureExecutionBudgetOutOfBounds, tipOrOrigin: TipOrOrigin) {
        self.encodingBase16 = encodingBase16
        self.anyDelegateRepresentativeCredential = anyDelegateRepresentativeCredential
        self.anyStakeCredential = anyStakeCredential
        self.deserialisationFailure = deserialisationFailure
        self.eraMismatch = eraMismatch
        self.evaluateTransactionFailure = evaluateTransactionFailure
        self.liveStakeDistribution = liveStakeDistribution
        self.nonces = nonces
        self.operationalCertificates = operationalCertificates
        self.mempoolSizeAndCapacity = mempoolSizeAndCapacity
        self.pointOrOrigin = pointOrOrigin
        self.projectedRewards = projectedRewards
        self.rewardAccountSummary = rewardAccountSummary
        self.rewardsProvenance = rewardsProvenance
        self.stakePoolsPerformances = stakePoolsPerformances
        self.scriptExecutionFailure = scriptExecutionFailure
        self.stakePoolSummary = stakePoolSummary
        self.submitTransactionFailure = submitTransactionFailure
        self.submitTransactionFailureExtraneousRedeemers = submitTransactionFailureExtraneousRedeemers
        self.submitTransactionFailureMissingDatums = submitTransactionFailureMissingDatums
        self.submitTransactionFailureUnknownOutputReference = submitTransactionFailureUnknownOutputReference
        self.submitTransactionFailureMissingCostModels = submitTransactionFailureMissingCostModels
        self.submitTransactionFailureExecutionBudgetOutOfBounds = submitTransactionFailureExecutionBudgetOutOfBounds
        self.tipOrOrigin = tipOrOrigin
    }
}
