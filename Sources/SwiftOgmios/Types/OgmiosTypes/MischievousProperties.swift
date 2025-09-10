// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mischievousProperties = try? newJSONDecoder().decode(MischievousProperties.self, from: jsonData)

import Foundation

// MARK: - MischievousProperties
public struct MischievousProperties: Codable, Sendable {
    public let invalidSignatories, missingSignatories, missingScripts, failingNativeScripts: ExtraneousRedeemers?
    public let extraneousScripts: ExtraneousRedeemers?
    public let metadata, provided, computed: Computed?
    public let missingRedeemers, extraneousDatums: ExtraneousRedeemers?
    public let providedScriptIntegrity, computedScriptIntegrity: TipOrOrigin?
    public let orphanScriptInputs, malformedScripts: ExtraneousRedeemers?
    public let validityInterval, currentSlot, measuredTransactionSize, maximumTransactionSize: PropertyNames?
    public let excessivelyLargeOutputs: ExtraneousRedeemers?
    public let minimumRequiredFee, providedFee, valueConsumed, valueProduced: PropertyNames?
    public let insufficientlyFundedOutputs: InsufficientlyFundedOutputs?
    public let bootstrapOutputs: ExtraneousRedeemers?
    public let providedCollateral, minimumRequiredCollateral: PropertyNames?
    public let unsuitableCollateralInputs: ExtraneousRedeemers?
    public let unforeseeableSlot, maximumCollateralInputs, countedCollateralInputs, unsuitableCollateralValue: PropertyNames?
    public let providedExecutionUnits, maximumExecutionUnits, declaredTotalCollateral, computedTotalCollateral: PropertyNames?
    public let declaredSpending: PropertyNames?
    public let mismatchReason: Message?
    public let unauthorizedVotes: DVotes?
    public let unknownProposals: ExtraneousRedeemers?
    public let unknownStakePool, incompleteWithdrawals, currentEpoch, declaredEpoch: PropertyNames?
    public let firstInvalidEpoch, minimumStakePoolCost, declaredStakePoolCost: PropertyNames?
    public let infringingStakePool: StakePool?
    public let computedMetadataHashSize, knownCredential, from, unknownCredential: PropertyNames?
    public let nonEmptyRewardAccountBalance: PropertyNames?
    public let marginalizedCredentials: ExtraneousRedeemers?
    public let providedDeposit, expectedDeposit, knownDelegateRepresentative, unknownDelegateRepresentative: PropertyNames?
    public let unknownConstitutionalCommitteeMember: UnknownConstitutionalCommitteeMember?
    public let conflictingMembers, alreadyRetiredMembers: Members?
    public let providedWithdrawal, computedWithdrawal: PropertyNames?
    public let invalidOrMissingPreviousProposals: InvalidOrMissingPreviousProposals?
    public let invalidVotes: DVotes?
    public let proposedVersion, currentVersion: PropertyNames?
    public let providedHash, expectedHash: TipOrOrigin?
    public let conflictingReferences: ExtraneousRedeemers?
    public let measuredReferenceScriptsSize, maximumReferenceScriptsSize: PropertyNames?
    public let unknownVoters: ExtraneousRedeemers?

    public init(invalidSignatories: ExtraneousRedeemers?, missingSignatories: ExtraneousRedeemers?, missingScripts: ExtraneousRedeemers?, failingNativeScripts: ExtraneousRedeemers?, extraneousScripts: ExtraneousRedeemers?, metadata: Computed?, provided: Computed?, computed: Computed?, missingRedeemers: ExtraneousRedeemers?, extraneousDatums: ExtraneousRedeemers?, providedScriptIntegrity: TipOrOrigin?, computedScriptIntegrity: TipOrOrigin?, orphanScriptInputs: ExtraneousRedeemers?, malformedScripts: ExtraneousRedeemers?, validityInterval: PropertyNames?, currentSlot: PropertyNames?, measuredTransactionSize: PropertyNames?, maximumTransactionSize: PropertyNames?, excessivelyLargeOutputs: ExtraneousRedeemers?, minimumRequiredFee: PropertyNames?, providedFee: PropertyNames?, valueConsumed: PropertyNames?, valueProduced: PropertyNames?, insufficientlyFundedOutputs: InsufficientlyFundedOutputs?, bootstrapOutputs: ExtraneousRedeemers?, providedCollateral: PropertyNames?, minimumRequiredCollateral: PropertyNames?, unsuitableCollateralInputs: ExtraneousRedeemers?, unforeseeableSlot: PropertyNames?, maximumCollateralInputs: PropertyNames?, countedCollateralInputs: PropertyNames?, unsuitableCollateralValue: PropertyNames?, providedExecutionUnits: PropertyNames?, maximumExecutionUnits: PropertyNames?, declaredTotalCollateral: PropertyNames?, computedTotalCollateral: PropertyNames?, declaredSpending: PropertyNames?, mismatchReason: Message?, unauthorizedVotes: DVotes?, unknownProposals: ExtraneousRedeemers?, unknownStakePool: PropertyNames?, incompleteWithdrawals: PropertyNames?, currentEpoch: PropertyNames?, declaredEpoch: PropertyNames?, firstInvalidEpoch: PropertyNames?, minimumStakePoolCost: PropertyNames?, declaredStakePoolCost: PropertyNames?, infringingStakePool: StakePool?, computedMetadataHashSize: PropertyNames?, knownCredential: PropertyNames?, from: PropertyNames?, unknownCredential: PropertyNames?, nonEmptyRewardAccountBalance: PropertyNames?, marginalizedCredentials: ExtraneousRedeemers?, providedDeposit: PropertyNames?, expectedDeposit: PropertyNames?, knownDelegateRepresentative: PropertyNames?, unknownDelegateRepresentative: PropertyNames?, unknownConstitutionalCommitteeMember: UnknownConstitutionalCommitteeMember?, conflictingMembers: Members?, alreadyRetiredMembers: Members?, providedWithdrawal: PropertyNames?, computedWithdrawal: PropertyNames?, invalidOrMissingPreviousProposals: InvalidOrMissingPreviousProposals?, invalidVotes: DVotes?, proposedVersion: PropertyNames?, currentVersion: PropertyNames?, providedHash: TipOrOrigin?, expectedHash: TipOrOrigin?, conflictingReferences: ExtraneousRedeemers?, measuredReferenceScriptsSize: PropertyNames?, maximumReferenceScriptsSize: PropertyNames?, unknownVoters: ExtraneousRedeemers?) {
        self.invalidSignatories = invalidSignatories
        self.missingSignatories = missingSignatories
        self.missingScripts = missingScripts
        self.failingNativeScripts = failingNativeScripts
        self.extraneousScripts = extraneousScripts
        self.metadata = metadata
        self.provided = provided
        self.computed = computed
        self.missingRedeemers = missingRedeemers
        self.extraneousDatums = extraneousDatums
        self.providedScriptIntegrity = providedScriptIntegrity
        self.computedScriptIntegrity = computedScriptIntegrity
        self.orphanScriptInputs = orphanScriptInputs
        self.malformedScripts = malformedScripts
        self.validityInterval = validityInterval
        self.currentSlot = currentSlot
        self.measuredTransactionSize = measuredTransactionSize
        self.maximumTransactionSize = maximumTransactionSize
        self.excessivelyLargeOutputs = excessivelyLargeOutputs
        self.minimumRequiredFee = minimumRequiredFee
        self.providedFee = providedFee
        self.valueConsumed = valueConsumed
        self.valueProduced = valueProduced
        self.insufficientlyFundedOutputs = insufficientlyFundedOutputs
        self.bootstrapOutputs = bootstrapOutputs
        self.providedCollateral = providedCollateral
        self.minimumRequiredCollateral = minimumRequiredCollateral
        self.unsuitableCollateralInputs = unsuitableCollateralInputs
        self.unforeseeableSlot = unforeseeableSlot
        self.maximumCollateralInputs = maximumCollateralInputs
        self.countedCollateralInputs = countedCollateralInputs
        self.unsuitableCollateralValue = unsuitableCollateralValue
        self.providedExecutionUnits = providedExecutionUnits
        self.maximumExecutionUnits = maximumExecutionUnits
        self.declaredTotalCollateral = declaredTotalCollateral
        self.computedTotalCollateral = computedTotalCollateral
        self.declaredSpending = declaredSpending
        self.mismatchReason = mismatchReason
        self.unauthorizedVotes = unauthorizedVotes
        self.unknownProposals = unknownProposals
        self.unknownStakePool = unknownStakePool
        self.incompleteWithdrawals = incompleteWithdrawals
        self.currentEpoch = currentEpoch
        self.declaredEpoch = declaredEpoch
        self.firstInvalidEpoch = firstInvalidEpoch
        self.minimumStakePoolCost = minimumStakePoolCost
        self.declaredStakePoolCost = declaredStakePoolCost
        self.infringingStakePool = infringingStakePool
        self.computedMetadataHashSize = computedMetadataHashSize
        self.knownCredential = knownCredential
        self.from = from
        self.unknownCredential = unknownCredential
        self.nonEmptyRewardAccountBalance = nonEmptyRewardAccountBalance
        self.marginalizedCredentials = marginalizedCredentials
        self.providedDeposit = providedDeposit
        self.expectedDeposit = expectedDeposit
        self.knownDelegateRepresentative = knownDelegateRepresentative
        self.unknownDelegateRepresentative = unknownDelegateRepresentative
        self.unknownConstitutionalCommitteeMember = unknownConstitutionalCommitteeMember
        self.conflictingMembers = conflictingMembers
        self.alreadyRetiredMembers = alreadyRetiredMembers
        self.providedWithdrawal = providedWithdrawal
        self.computedWithdrawal = computedWithdrawal
        self.invalidOrMissingPreviousProposals = invalidOrMissingPreviousProposals
        self.invalidVotes = invalidVotes
        self.proposedVersion = proposedVersion
        self.currentVersion = currentVersion
        self.providedHash = providedHash
        self.expectedHash = expectedHash
        self.conflictingReferences = conflictingReferences
        self.measuredReferenceScriptsSize = measuredReferenceScriptsSize
        self.maximumReferenceScriptsSize = maximumReferenceScriptsSize
        self.unknownVoters = unknownVoters
    }
}
