// MARK: - Supporting Types for SubmitTransactionFailure



// ScriptPurpose from cardano.json - using enum to handle different types


// MARK: - SubmitTransactionFailure Protocol

public protocol SubmitTransactionFailure: JSONRPCError {}
    
/// Failed to submit the transaction in the current era. This may happen when trying to submit a
/// transaction near an era boundary (i.e. at the moment of a hard-fork).
public struct SubmitTransactionFailureEraMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: EraMismatch
    
    init(code: Int = 3005, message: String, data: EraMismatch) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some signatures are invalid. Only the serialised transaction *body*, without metadata or witnesses, must be signed.
public struct SubmitTransactionFailureInvalidSignatories: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: InvalidSignatoriesData
    
    public struct InvalidSignatoriesData: JSONSerializable {
        public let invalidSignatories: [VerificationKey]
    }
    
    init(code: Int = 3100, message: String, data: InvalidSignatoriesData) {
        self.code = code
        self.message = message
        self.data = data
    }
    
}

/// Some signatures are missing. A signed transaction must carry signatures for all inputs locked by verification keys or a native script. Transaction may also need signatures for each required extra signatories often required by Plutus Scripts.
public struct SubmitTransactionFailureMissingSignatories: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MissingSignatoriesData
    
    public struct MissingSignatoriesData: JSONSerializable {
        public let missingSignatories: [DigestBlake2b224]
    }
    
    init(code: Int = 3101, message: String, data: MissingSignatoriesData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some script witnesses are missing. Indeed, any script used in a transaction (when spending, minting, withdrawing or publishing certificates) must be provided in full with the transaction. Scripts must therefore be added either to the witness set or provided as a reference inputs should you use Plutus V2+ and a format from Babbage and beyond.
public struct SubmitTransactionFailureMissingScripts: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MissingScriptsData
    
    public struct MissingScriptsData: JSONSerializable {
        public let missingScripts: [DigestBlake2b224]
    }
    
    init(code: Int = 3102, message: String, data: MissingScriptsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction contains failing phase-1 monetary scripts (a.k.a. native scripts). This can be due to either a missing or invalid signature, or because of a time validity issue. The field 'data.failingNativeScripts' contains a list of hash digests of all failing native scripts found in the transaction.
public struct SubmitTransactionFailureFailingNativeScript: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: FailingNativeScriptsData
    
    public struct FailingNativeScriptsData: JSONSerializable {
        public let failingNativeScripts: [DigestBlake2b224]
    }
    
    init(code: Int = 3103, message: String, data: FailingNativeScriptsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Extraneous (i.e. non-required) scripts found in the transaction. A transaction must not contain scripts that aren't strictly needed for validation, that are present in metadata or that are published in an output. Perhaps you have used provided a wrong script for a validator? Anyway, the 'data.extraneousScripts' field lists hash digests of scripts found to be extraneous.
public struct SubmitTransactionFailureExtraneousScripts: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ExtraneousScriptsData
    
    public struct ExtraneousScriptsData: JSONSerializable {
        public let extraneousScripts: [DigestBlake2b224]
    }
    
    init(code: Int = 3104, message: String, data: ExtraneousScriptsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Missing required metadata hash in the transaction body. If the transaction includes metadata, then it must also include a hash digest of these serialised metadata in its body to prevent malicious actors from tempering with the data. The field 'data.metadata.hash' contains the expected missing hash digest of the metadata found in the transaction.
public struct SubmitTransactionFailureMissingMetadataHash: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MissingMetadataHashData
    
    public struct MissingMetadataHashData: JSONSerializable {
        public let metadata: MetadataInfo
        
        public struct MetadataInfo: JSONSerializable {
            public let hash: DigestBlake2b256
        }
    }
    
    init(code: Int = 3105, message: String, data: MissingMetadataHashData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// No metadata corresponding to a specified metadata hash. It appears that you might have forgotten to attach metadata to a transaction, yet included a hash digest of them in the transaction body? The field 'data.metadata.hash' contains the orphan hash found in the body.
public struct SubmitTransactionFailureMissingMetadata: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MissingMetadataData
    
    public struct MissingMetadataData: JSONSerializable {
        public let metadata: MetadataInfo
        
        public struct MetadataInfo: JSONSerializable {
            public let hash: DigestBlake2b256
        }
    }
    
    init(code: Int = 3106, message: String, data: MissingMetadataData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// There's a mismatch between the provided metadata hash digest and the one computed from the actual metadata. The two must match exactly. The field 'data.provided.hash' references the provided hash as found in the transaction body, whereas 'data.computed.hash' contains the one the ledger computed from the actual metadata.
public struct SubmitTransactionFailureMetadataHashMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MetadataHashMismatchData
    
    public struct MetadataHashMismatchData: JSONSerializable {
        public let provided: HashInfo
        public let computed: HashInfo
        
        public struct HashInfo: JSONSerializable {
            public let hash: DigestBlake2b256
        }
    }
    
    init(code: Int = 3107, message: String, data: MetadataHashMismatchData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Invalid metadatum found in transaction metadata. Metadata byte strings must be no longer than 64-bytes and text strings must be no longer than 64 bytes once UTF-8-encoded. Some metadatum in the transaction infringe this rule.
public struct SubmitTransactionFailureInvalidMetadata: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3108, message: String) {
        self.code = code
        self.message = message
    }
}

/// Missing required redeemer(s) for Plutus scripts. There are validators needed for the transaction that do not have an associated redeemer. Redeemer are provided when trying to execute the validation logic of a script (e.g. when spending from an input locked by a script, or minting assets from a Plutus monetary policy. The field 'data.missingRedeemers' lists the different purposes for which a redeemer hasn't been provided.
public struct SubmitTransactionFailureMissingRedeemers: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MissingRedeemersData
    
    public struct MissingRedeemersData: JSONSerializable {
        public let missingRedeemers: [ScriptPurpose]
    }
    
    init(code: Int = 3109, message: String, data: MissingRedeemersData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Extraneous (non-required) redeemers found in the transaction. There are some redeemers that aren't pointing to any script. This could be because you've left some orphan redeemer behind, because they are pointing at the wrong thing or because you forgot to include their associated validator. Either way, the field 'data.extraneousRedeemers' lists the different orphan redeemer pointers.
public struct SubmitTransactionFailureExtraneousRedeemers: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ExtraneousRedeemersData
    
    public struct ExtraneousRedeemersData: JSONSerializable {
        public let extraneousRedeemers: [RedeemerPointer]
    }
    
    init(code: Int = 3110, message: String, data: ExtraneousRedeemersData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Transaction failed because some Plutus scripts are missing their associated datums. 'data.missingDatums' contains a set of data hashes for the missing datums. Ensure all Plutus scripts have an associated datum in the transaction's witness set or, are provided through inline datums in reference inputs.
public struct SubmitTransactionFailureMissingDatums: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MissingDatumsData
    
    public struct MissingDatumsData: JSONSerializable {
        public let missingDatums: [DigestBlake2b256]
    }
    
    init(code: Int = 3111, message: String, data: MissingDatumsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction failed because it contains datums not associated with any script or output. This could be because you've left some orphan datum behind, because you've listed the wrong inputs in the transaction or because you've just forgotten to include a datum associated with an input. Either way, the field 'data.extraneousDatums' contains a set of data hashes for these extraneous datums.
public struct SubmitTransactionFailureExtraneousDatums: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ExtraneousDatumsData
    
    public struct ExtraneousDatumsData: JSONSerializable {
        public let extraneousDatums: [DigestBlake2b256]
    }
    
    init(code: Int = 3112, message: String, data: ExtraneousDatumsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction failed because the provided script integrity hash doesn't match the computed one. This is crucial for ensuring the integrity of cost models and Plutus version used during script execution. The field 'data.providedScriptIntegrity' correspond to what was given, if any, and 'data.computedScriptIntegrity' is what was expected. If the latter is null, this means you shouldn't have included a script integrity hash to begin with.
public struct SubmitTransactionFailureScriptIntegrityHashMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ScriptIntegrityHashMismatchData
    
    public struct ScriptIntegrityHashMismatchData: JSONSerializable {
        public let providedScriptIntegrity: DigestBlake2b256?
        public let computedScriptIntegrity: DigestBlake2b256?
    }
    
    init(code: Int = 3113, message: String, data: ScriptIntegrityHashMismatchData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// This is bad, you're trying to spend inputs that are locked by Plutus scripts, but have no associated datums. Those inputs are so-to-speak unspendable (at least with the current ledger rules). There's nothing you can do apart from re-creating these UTxOs but with a corresponding datum this time. The field 'data.orphanScriptInputs' lists all such inputs found in the transaction.
public struct SubmitTransactionFailureOrphanScriptInputs: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: OrphanScriptInputsData
    
    public struct OrphanScriptInputsData: JSONSerializable {
        public let orphanScriptInputs: [TransactionOutputReference]
    }
    
    init(code: Int = 3114, message: String, data: OrphanScriptInputsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// It seems like the transaction is using a Plutus version for which there's no available cost model yet. This could be because that language version is known of the ledger but hasn't yet been enabled through hard-fork. The field 'data.missingCostModels' lists all the languages for which a cost model is missing.
public struct SubmitTransactionFailureMissingCostModels: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MissingCostModelsData
    
    public struct MissingCostModelsData: JSONSerializable {
        public let missingCostModels: [Language]
    }
    
    init(code: Int = 3115, message: String, data: MissingCostModelsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some Plutus scripts in the witness set or in an output are invalid. Scripts must be well-formed flat-encoded Plutus scripts, CBOR-encoded. Yes, there's a double binary encoding. The outer-most encoding is therefore just a plain CBOR bytestring. Note that some tools such as the cardano-cli triple encode scripts for some reasons, resulting in a double outer-most CBOR encoding. Make sure that your script are correctly encoded. The field 'data.malformedScripts' lists the hash digests of all the problematic scripts.
public struct SubmitTransactionFailureMalformedScripts: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MalformedScriptsData
    
    public struct MalformedScriptsData: JSONSerializable {
        public let malformedScripts: [DigestBlake2b224]
    }
    
    init(code: Int = 3116, message: String, data: MalformedScriptsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction contains unknown UTxO references as inputs. This can happen if the inputs you're trying to spend have already been spent, or if you've simply referred to non-existing UTxO altogether. The field 'data.unknownOutputReferences' indicates all unknown inputs.
public struct SubmitTransactionFailureUnknownOutputReference: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnknownOutputReferenceData
    
    public struct UnknownOutputReferenceData: JSONSerializable {
        public let unknownOutputReferences: [TransactionOutputReference]
    }
    
    init(code: Int = 3117, message: String, data: UnknownOutputReferenceData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction is outside of its validity interval. It was either submitted too early or too late. A transaction that has a lower validity bound can only be accepted by the ledger (and make it to the mempool) if the ledger's current slot is greater than the specified bound. The upper bound works similarly, as a time to live. The field 'data.currentSlot' contains the current slot as known of the ledger (this may be different from the current network slot if the ledger is still catching up). The field 'data.validityInterval' is a reminder of the validity interval provided with the transaction.
public struct SubmitTransactionFailureOutsideOfValidityInterval: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: OutsideOfValidityIntervalData
    
    public struct OutsideOfValidityIntervalData: JSONSerializable {
        public let validityInterval: ValidityInterval
        public let currentSlot: Slot
    }
    
    init(code: Int = 3118, message: String, data: OutsideOfValidityIntervalData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction exceeds the maximum size allowed by the protocol. Indeed, once serialized, transactions must be under a bytes limit specified by a protocol parameter. The field 'data.measuredTransactionSize' indicates the actual measured size of your serialized transaction, whereas 'data.maximumTransactionSize' indicates the current maximum size enforced by the ledger.
public struct SubmitTransactionFailureTransactionTooLarge: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: TransactionTooLargeData
    
    public struct TransactionTooLargeData: JSONSerializable {
        public let measuredTransactionSize: NumberOfBytes
        public let maximumTransactionSize: NumberOfBytes
    }
    
    init(code: Int = 3119, message: String, data: TransactionTooLargeData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Transaction must have at least one input, but this one has an empty input set. One input is necessary to prevent replayability of transactions, as it piggybacks on the unique spendable property of UTxO.
public struct SubmitTransactionFailureEmptyInputSet: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3121, message: String) {
        self.code = code
        self.message = message
    }
}

/// Insufficient fee! The transaction doesn't not contain enough fee to cover the minimum required by the protocol. Note that fee depends on (a) a flat cost fixed by the protocol, (b) the size of the serialized transaction, (c) the budget allocated for Plutus script execution. The field 'data.minimumRequiredFee' indicates the minimum required fee whereas 'data.providedFee' refers to the fee currently supplied with the transaction.
public struct SubmitTransactionFailureTransactionFeeTooSmall: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: TransactionFeeTooSmallData
    
    public struct TransactionFeeTooSmallData: JSONSerializable {
        public let minimumRequiredFee: ValueAdaOnly
        public let providedFee: ValueAdaOnly
    }
    
    init(code: Int = 3122, message: String, data: TransactionFeeTooSmallData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// In and out value not conserved. The transaction must *exactly* balance: every input must be accounted for. There are various things counting as 'in balance': (a) the total value locked by inputs (or collateral inputs in case of a failing script), (b) rewards coming from withdrawals and (c) return deposits from stake credential or pool de-registration. In a similar fashion, various things count towards the 'out balance': (a) the total value assigned to each transaction output, (b) the fee and (c) any deposit for stake credential or pool registration. The field 'data.valueConsumed' contains the total 'in balance', and 'data.valueProduced' indicates the total amount counting as 'out balance'.
public struct SubmitTransactionFailureValueNotConserved: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ValueNotConservedData
    
    public struct ValueNotConservedData: JSONSerializable {
        public let valueConsumed: Value
        public let valueProduced: Value
    }
    
    init(code: Int = 3123, message: String, data: ValueNotConservedData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction ran out of execution budget! This means that the budget granted for the execution of a particular script was too small or exceeding the maximum value allowed by the protocol. The field 'data.budgetUsed' indicates the actual execution units used by the validator before it was interrupted.
public struct SubmitTransactionFailureExecutionBudgetOutOfBounds: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ExecutionBudgetOutOfBoundsData
    
    public struct ExecutionBudgetOutOfBoundsData: JSONSerializable {
        public let budgetUsed: ExecutionUnits
    }
    
    init(code: Int = 3161, message: String, data: ExecutionBudgetOutOfBoundsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// A transaction was rejected due to custom rules that prevented it from entering the mempool. A justification is given as 'data.error'.
public struct SubmitTransactionFailureUnexpectedMempoolError: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnexpectedMempoolErrorData
    
    public struct UnexpectedMempoolErrorData: JSONSerializable {
        public let error: String
    }
    
    init(code: Int = 3997, message: String, data: UnexpectedMempoolErrorData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some output values in the transaction are too large. Once serialized, values must be below a certain threshold.
public struct SubmitTransactionFailureValueTooLarge: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ValueTooLargeData
    
    public struct ValueTooLargeData: JSONSerializable {
        public let excessivelyLargeOutputs: [TransactionOutput]
    }
    
    init(code: Int = 3120, message: String, data: ValueTooLargeData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some discriminated entities in the transaction are configured for another network.
public struct SubmitTransactionFailureNetworkMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: NetworkMismatchData
    
    public struct NetworkMismatchData: JSONSerializable {
        public let expectedNetwork: Network
        public let discriminatedType: String
        public let invalidEntities: [String]?
    }
    
    init(code: Int = 3124, message: String, data: NetworkMismatchData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some outputs have an insufficient amount of Ada attached to them.
public struct SubmitTransactionFailureInsufficientlyFundedOutputs: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: InsufficientlyFundedOutputsData
    
    public struct InsufficientlyFundedOutputsData: JSONSerializable {
        public let insufficientlyFundedOutputs: [InsufficientOutput]
        
        public struct InsufficientOutput: JSONSerializable {
            public let output: TransactionOutput
            public let minimumRequiredValue: ValueAdaOnly?
        }
    }
    
    init(code: Int = 3125, message: String, data: InsufficientlyFundedOutputsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some output associated with legacy / bootstrap addresses have attributes that are too large.
public struct SubmitTransactionFailureBootstrapAttributesTooLarge: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: BootstrapAttributesTooLargeData
    
    public struct BootstrapAttributesTooLargeData: JSONSerializable {
        public let bootstrapOutputs: [TransactionOutput]
    }
    
    init(code: Int = 3126, message: String, data: BootstrapAttributesTooLargeData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction is attempting to mint or burn Ada tokens.
public struct SubmitTransactionFailureMintingOrBurningAda: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3127, message: String) {
        self.code = code
        self.message = message
    }
}

/// Insufficient collateral value for Plutus scripts in the transaction.
public struct SubmitTransactionFailureInsufficientCollateral: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: InsufficientCollateralData
    
    public struct InsufficientCollateralData: JSONSerializable {
        public let providedCollateral: Value
        public let minimumRequiredCollateral: ValueAdaOnly
    }
    
    init(code: Int = 3128, message: String, data: InsufficientCollateralData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Invalid choice of collateral: an input provided for collateral is locked by script.
public struct SubmitTransactionFailureCollateralLockedByScript: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: CollateralLockedByScriptData
    
    public struct CollateralLockedByScriptData: JSONSerializable {
        public let unsuitableCollateralInputs: [TransactionOutputReference]
    }
    
    init(code: Int = 3129, message: String, data: CollateralLockedByScriptData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// One of the transaction validity bound is outside any foreseeable future.
public struct SubmitTransactionFailureUnforeseeableSlot: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnforeseeableSlotData
    
    public struct UnforeseeableSlotData: JSONSerializable {
        public let unforeseeableSlot: Slot
    }
    
    init(code: Int = 3130, message: String, data: UnforeseeableSlotData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction contains too many collateral inputs.
public struct SubmitTransactionFailureTooManyCollateralInputs: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: TooManyCollateralInputsData
    
    public struct TooManyCollateralInputsData: JSONSerializable {
        public let maximumCollateralInputs: UInt32
        public let countedCollateralInputs: UInt32
    }
    
    init(code: Int = 3131, message: String, data: TooManyCollateralInputsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction doesn't provide any collateral inputs but it must.
public struct SubmitTransactionFailureMissingCollateralInputs: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3132, message: String) {
        self.code = code
        self.message = message
    }
}

/// One of the input provided as collateral carries something else than Ada tokens.
public struct SubmitTransactionFailureNonAdaCollateral: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: NonAdaCollateralData
    
    public struct NonAdaCollateralData: JSONSerializable {
        public let unsuitableCollateralValue: Value
    }
    
    init(code: Int = 3133, message: String, data: NonAdaCollateralData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction execution budget for scripts execution is above the allowed limit.
public struct SubmitTransactionFailureExecutionUnitsTooLarge: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ExecutionUnitsTooLargeData
    
    public struct ExecutionUnitsTooLargeData: JSONSerializable {
        public let providedExecutionUnits: ExecutionUnits
        public let maximumExecutionUnits: ExecutionUnits
    }
    
    init(code: Int = 3134, message: String, data: ExecutionUnitsTooLargeData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// There's a mismatch between the declared total collateral amount, and the value computed from the inputs and outputs.
public struct SubmitTransactionFailureTotalCollateralMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: TotalCollateralMismatchData
    
    public struct TotalCollateralMismatchData: JSONSerializable {
        public let declaredTotalCollateral: ValueAdaOnly
        public let computedTotalCollateral: Value
    }
    
    init(code: Int = 3135, message: String, data: TotalCollateralMismatchData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Invalid transaction submitted as valid, or vice-versa.
public struct SubmitTransactionFailureSpendsMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: SpendsMismatchData
    
    public struct SpendsMismatchData: JSONSerializable {
        public let declaredSpending: String
        public let mismatchReason: String
    }
    
    init(code: Int = 3136, message: String, data: SpendsMismatchData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction contains votes from unauthorized voters.
public struct SubmitTransactionFailureUnauthorizedVotes: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnauthorizedVotesData
    
    public struct UnauthorizedVotesData: JSONSerializable {
        public let unauthorizedVotes: [UnauthorizedVote]
        
        public struct UnauthorizedVote: JSONSerializable {
            public let proposal: String // GovernanceProposalReference
            public let voter: String // GovernanceVoter
        }
    }
    
    init(code: Int = 3137, message: String, data: UnauthorizedVotesData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Reference(s) to unknown governance proposals found in transaction.
public struct SubmitTransactionFailureUnknownGovernanceProposals: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnknownGovernanceProposalsData
    
    public struct UnknownGovernanceProposalsData: JSONSerializable {
        public let unknownProposals: [String] // GovernanceProposalReference
    }
    
    init(code: Int = 3138, message: String, data: UnknownGovernanceProposalsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction contains an invalid or unauthorized protocol parameters update.
public struct SubmitTransactionFailureInvalidProtocolParametersUpdate: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3139, message: String) {
        self.code = code
        self.message = message
    }
}

/// The transaction references an unknown stake pool.
public struct SubmitTransactionFailureUnknownStakePool: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnknownStakePoolData
    
    public struct UnknownStakePoolData: JSONSerializable {
        public let unknownStakePool: String // StakePoolId
    }
    
    init(code: Int = 3140, message: String, data: UnknownStakePoolData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction contains incomplete or invalid rewards withdrawals.
public struct SubmitTransactionFailureIncompleteWithdrawals: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: IncompleteWithdrawalsData
    
    public struct IncompleteWithdrawalsData: JSONSerializable {
        public let incompleteWithdrawals: [String: ValueAdaOnly] // Withdrawals
    }
    
    init(code: Int = 3141, message: String, data: IncompleteWithdrawalsData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// A stake pool retirement certificate is trying to retire too late in the future.
public struct SubmitTransactionFailureRetirementTooLate: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: RetirementTooLateData
    
    public struct RetirementTooLateData: JSONSerializable {
        public let currentEpoch: Epoch
        public let declaredEpoch: Epoch
        public let firstInvalidEpoch: Epoch
    }
    
    init(code: Int = 3142, message: String, data: RetirementTooLateData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Stake pool cost declared are below the allowed minimum.
public struct SubmitTransactionFailureStakePoolCostTooLow: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: StakePoolCostTooLowData
    
    public struct StakePoolCostTooLowData: JSONSerializable {
        public let minimumStakePoolCost: ValueAdaOnly
        public let declaredStakePoolCost: ValueAdaOnly
    }
    
    init(code: Int = 3143, message: String, data: StakePoolCostTooLowData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some hash digest of stake pool metadata is too long.
public struct SubmitTransactionFailureMetadataHashTooLarge: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MetadataHashTooLargeData
    
    public struct MetadataHashTooLargeData: JSONSerializable {
        public let infringingStakePool: StakePoolInfo
        public let computedMetadataHashSize: NumberOfBytes
        
        public struct StakePoolInfo: JSONSerializable {
            public let id: String // StakePoolId
        }
    }
    
    init(code: Int = 3144, message: String, data: MetadataHashTooLargeData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Trying to re-register some already known credentials.
public struct SubmitTransactionFailureCredentialAlreadyRegistered: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: CredentialAlreadyRegisteredData
    
    public struct CredentialAlreadyRegisteredData: JSONSerializable {
        public let knownCredential: DigestBlake2b224
        public let from: CredentialOrigin
    }
    
    init(code: Int = 3145, message: String, data: CredentialAlreadyRegisteredData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction references an unknown stake credential.
public struct SubmitTransactionFailureUnknownCredential: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnknownCredentialData
    
    public struct UnknownCredentialData: JSONSerializable {
        public let unknownCredential: DigestBlake2b224
        public let from: CredentialOrigin
    }
    
    init(code: Int = 3146, message: String, data: UnknownCredentialData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Trying to unregister stake credentials associated to a non empty reward account.
public struct SubmitTransactionFailureNonEmptyRewardAccount: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: NonEmptyRewardAccountData
    
    public struct NonEmptyRewardAccountData: JSONSerializable {
        public let nonEmptyRewardAccountBalance: ValueAdaOnly
    }
    
    init(code: Int = 3147, message: String, data: NonEmptyRewardAccountData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction includes a governance proposal that doesn't exist.
public struct SubmitTransactionFailureUnknownGenesisKey: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnknownGenesisKeyData
    
    public struct UnknownGenesisKeyData: JSONSerializable {
        public let unknownGenesisKey: DigestBlake2b224
    }
    
    init(code: Int = 3148, message: String, data: UnknownGenesisKeyData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Attempting to delegate to a non-existing stake pool.
public struct SubmitTransactionFailureDelegationToNonExistentPool: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: DelegationToNonExistentPoolData
    
    public struct DelegationToNonExistentPoolData: JSONSerializable {
        public let nonExistentStakePool: String // StakePoolId
    }
    
    init(code: Int = 3149, message: String, data: DelegationToNonExistentPoolData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Governance proposal is improperly formed.
public struct SubmitTransactionFailureInvalidGovernanceProposal: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3150, message: String) {
        self.code = code
        self.message = message
    }
}

/// Invalid transaction validity bound.
public struct SubmitTransactionFailureInvalidTxValidityUpperBound: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: InvalidTxValidityUpperBoundData
    
    public struct InvalidTxValidityUpperBoundData: JSONSerializable {
        public let invalidAfter: Slot?
        public let beyondTimeHorizon: Slot
    }
    
    init(code: Int = 3152, message: String, data: InvalidTxValidityUpperBoundData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Auxiliary data hash mismatch.
public struct SubmitTransactionFailureAuxiliaryDataHashMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: AuxiliaryDataHashMismatchData
    
    public struct AuxiliaryDataHashMismatchData: JSONSerializable {
        public let expectedAuxiliaryDataHash: DigestBlake2b256
        public let computedAuxiliaryDataHash: DigestBlake2b256
    }
    
    init(code: Int = 3153, message: String, data: AuxiliaryDataHashMismatchData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Minimum UTxO requirement not met for one or many transaction outputs.
public struct SubmitTransactionFailureMinimumUtxoValueNotMet: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MinimumUtxoValueNotMetData
    
    public struct MinimumUtxoValueNotMetData: JSONSerializable {
        public let infringingOutputs: [InfringingOutput]
        
        public struct InfringingOutput: JSONSerializable {
            public let index: Int
            public let output: TransactionOutput
            public let minimumRequiredValue: Value
        }
    }
    
    init(code: Int = 3155, message: String, data: MinimumUtxoValueNotMetData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction size exceeds the protocol limit.
public struct SubmitTransactionFailureTransactionSizeTooBig: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: TransactionSizeTooBigData
    
    public struct TransactionSizeTooBigData: JSONSerializable {
        public let actualTransactionSize: NumberOfBytes
        public let maximumTransactionSize: NumberOfBytes
    }
    
    init(code: Int = 3156, message: String, data: TransactionSizeTooBigData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Native scripts lock is not correctly provided.
public struct SubmitTransactionFailureNativeScriptNotAllowed: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: NativeScriptNotAllowedData
    
    public struct NativeScriptNotAllowedData: JSONSerializable {
        public let script: Script
    }
    
    init(code: Int = 3157, message: String, data: NativeScriptNotAllowedData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// A pool already exists with the same identifier.
public struct SubmitTransactionFailureStakePoolAlreadyRegistered: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: StakePoolAlreadyRegisteredData
    
    public struct StakePoolAlreadyRegisteredData: JSONSerializable {
        public let knownStakePool: String // StakePoolId
    }
    
    init(code: Int = 3158, message: String, data: StakePoolAlreadyRegisteredData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Too many assets in a transaction output.
public struct SubmitTransactionFailureTooManyAssetsInOutput: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: TooManyAssetsInOutputData
    
    public struct TooManyAssetsInOutputData: JSONSerializable {
        public let infringingOutput: TransactionOutput
        public let assetCount: Int
        public let maximumAssetCount: Int
    }
    
    init(code: Int = 3159, message: String, data: TooManyAssetsInOutputData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction validity range is negative.
public struct SubmitTransactionFailureInvalidValidityRange: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: InvalidValidityRangeData
    
    public struct InvalidValidityRangeData: JSONSerializable {
        public let invalidBefore: Slot?
        public let invalidAfter: Slot?
    }
    
    init(code: Int = 3160, message: String, data: InvalidValidityRangeData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Extra signatories found in the transaction.
public struct SubmitTransactionFailureExtraSignatories: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ExtraSignatoriesData
    
    public struct ExtraSignatoriesData: JSONSerializable {
        public let extraSignatories: [DigestBlake2b224]
    }
    
    init(code: Int = 3161, message: String, data: ExtraSignatoriesData) {
        self.code = code
        self.message = message
        self.data = data
    }
}


/// Transaction's minted value doesn't match the sum of assets being minted.
public struct SubmitTransactionFailureMintValueMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: MintValueMismatchData
    
    public struct MintValueMismatchData: JSONSerializable {
        public let mintedValue: Value
        public let expectedValue: Value
    }
    
    init(code: Int = 3163, message: String, data: MintValueMismatchData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Asset name exceeds maximum length.
public struct SubmitTransactionFailureAssetNameTooLong: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: AssetNameTooLongData
    
    public struct AssetNameTooLongData: JSONSerializable {
        public let assetName: String
        public let assetNameLength: Int
        public let maximumAssetNameLength: Int
    }
    
    init(code: Int = 3164, message: String, data: AssetNameTooLongData) {
        self.code = code
        self.message = message
        self.data = data
    }
}


/// The deposit specified in a stake credential registration does not match the current value set by protocol parameters.
public struct SubmitTransactionFailureCredentialDepositMismatch: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: CredentialDepositMismatchData
    
    public struct CredentialDepositMismatchData: JSONSerializable {
        public let providedDeposit: ValueAdaOnly
        public let expectedDeposit: ValueAdaOnly?
    }
    
    init(code: Int = 3151, message: String, data: CredentialDepositMismatchData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction references an unknown constitutional committee member.
public struct SubmitTransactionFailureUnknownConstitutionalCommitteeMember: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnknownConstitutionalCommitteeMemberData
    
    public struct UnknownConstitutionalCommitteeMemberData: JSONSerializable {
        public let unknownConstitutionalCommitteeMember: ConstitutionalCommitteeMember
        
        public struct ConstitutionalCommitteeMember: JSONSerializable {
            public let id: DigestBlake2b224
            public let from: CredentialOrigin
        }
    }
    
    init(code: Int = 3154, message: String, data: UnknownConstitutionalCommitteeMemberData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Identical UTxO references were found in both the transaction inputs and references.
public struct SubmitTransactionFailureConflictingInputsAndReferences: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ConflictingInputsAndReferencesData
    
    public struct ConflictingInputsAndReferencesData: JSONSerializable {
        public let conflictingReferences: [TransactionOutputReference]
    }
    
    init(code: Int = 3164, message: String, data: ConflictingInputsAndReferencesData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The ledger is still in a bootstrapping phase - only certain governance actions are authorized.
public struct SubmitTransactionFailureUnauthorizedGovernanceAction: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3165, message: String) {
        self.code = code
        self.message = message
    }
}

/// Reference scripts are too large.
public struct SubmitTransactionFailureReferenceScriptsTooLarge: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: ReferenceScriptsTooLargeData
    
    public struct ReferenceScriptsTooLargeData: JSONSerializable {
        public let measuredReferenceScriptsSize: NumberOfBytes
        public let maximumReferenceScriptsSize: NumberOfBytes
    }
    
    init(code: Int = 3166, message: String, data: ReferenceScriptsTooLargeData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some voters in the transaction are unknown.
public struct SubmitTransactionFailureUnknownVoters: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnknownVotersData
    
    public struct UnknownVotersData: JSONSerializable {
        public let unknownVoters: [String] // GovernanceVoter
    }
    
    init(code: Int = 3167, message: String, data: UnknownVotersData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some proposals contain empty treasury withdrawals.
public struct SubmitTransactionFailureEmptyTreasuryWithdrawal: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3168, message: String) {
        self.code = code
        self.message = message
    }
}

/// Unrecognized certificate type. This error is a placeholder due to how internal data-types are modeled. If you ever run into this, please report the issue as you've likely discoverd a critical bug...
public struct SubmitTransactionFailureUnrecognizedCertificateType: SubmitTransactionFailure {
    public let code: Int
    public let message: String
    
    init(code: Int = 3998, message: String) {
        self.code = code
        self.message = message
    }
}
