import Foundation

// MARK: - EvaluateTransactionFailure Protocol

public protocol EvaluateTransactionFailure: JSONRPCError {}

/// Returned when trying to evaluate execution units of a pre-Alonzo transaction.
public struct EvaluateTransactionFailureIncompatibleEra: EvaluateTransactionFailure {
    public let code: Int
    public let message: String
    public let data: IncompatibleEraData
    
    public struct IncompatibleEraData: JSONSerializable {
        public let incompatibleEra: Era
    }
    
    init(code: Int = 3000, message: String, data: IncompatibleEraData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Returned when trying to evaluate execution units of an era that is now considered too old and is no longer supported.
public struct EvaluateTransactionFailureUnsupportedEra: EvaluateTransactionFailure {
    public let code: Int
    public let message: String
    public let data: UnsupportedEraData
    
    public struct UnsupportedEraData: JSONSerializable {
        public let unsupportedEra: Era
    }
    
    init(code: Int = 3001, message: String, data: UnsupportedEraData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Happens when providing an additional UTXO set which overlaps with the UTXO on-chain.
public struct EvaluateTransactionFailureOverlappingAdditionalUtxo: EvaluateTransactionFailure {
    public let code: Int
    public let message: String
    public let data: OverlappingAdditionalUtxoData
    
    public struct OverlappingAdditionalUtxoData: JSONSerializable {
        public let overlappingOutputReferences: [TransactionOutputReference]
    }
    
    init(code: Int = 3002, message: String, data: OverlappingAdditionalUtxoData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Happens when attempting to evaluate execution units on a node that isn't enough synchronized.
public struct EvaluateTransactionFailureNodeTipTooOld: EvaluateTransactionFailure {
    public let code: Int
    public let message: String
    public let data: NodeTipTooOldData
    
    public struct NodeTipTooOldData: JSONSerializable {
        public let currentNodeEra: Era
        public let minimumRequiredEra: Era
    }
    
    init(code: Int = 3003, message: String, data: NodeTipTooOldData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// The transaction is malformed or missing information; making evaluation impossible.
public struct EvaluateTransactionFailureCannotCreateEvaluationContext: EvaluateTransactionFailure {
    public let code: Int
    public let message: String
    public let data: CannotCreateEvaluationContextData
    
    public struct CannotCreateEvaluationContextData: JSONSerializable {
        public let reason: String
    }
    
    init(code: Int = 3004, message: String, data: CannotCreateEvaluationContextData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// One or more script execution terminated with an error.
public struct EvaluateTransactionFailureScriptExecutionFailure: EvaluateTransactionFailure {
    public let code: Int
    public let message: String
    public let data: [ScriptExecutionFailureItem]
    
    public struct ScriptExecutionFailureItem: JSONSerializable {
        public let validator: RedeemerPointer
        public let error: ScriptExecutionFailureType
    }
    
    init(code: Int = 3010, message: String, data: [ScriptExecutionFailureItem]) {
        self.code = code
        self.message = message
        self.data = data
    }
}