import Foundation

// MARK: - ScriptExecutionFailure Protocol

public protocol ScriptExecutionFailure: JSONRPCError {}

/// Some script witnesses are missing.
public struct ScriptExecutionFailureInvalidRedeemerPointers: ScriptExecutionFailure {
    public let code: Int
    public let message: String
    public let data: InvalidRedeemerPointersData
    
    public struct InvalidRedeemerPointersData: JSONSerializable {
        public let missingScripts: [RedeemerPointer]
    }
    
    init(code: Int = 3011, message: String, data: InvalidRedeemerPointersData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// Some of the scripts failed to evaluate to a positive outcome.
public struct ScriptExecutionFailureValidationFailure: ScriptExecutionFailure {
    public let code: Int
    public let message: String
    public let data: ValidationFailureData
    
    public struct ValidationFailureData: JSONSerializable {
        public let validationError: String
        public let traces: [String]
    }
    
    init(code: Int = 3012, message: String, data: ValidationFailureData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

/// A redeemer points to an input that isn't locked by a Plutus script.
public struct ScriptExecutionFailureUnsuitableOutputReference: ScriptExecutionFailure {
    public let code: Int
    public let message: String
    public let data: UnsuitableOutputReferenceData
    
    public struct UnsuitableOutputReferenceData: JSONSerializable {
        public let unsuitableOutputReference: TransactionOutputReference
    }
    
    init(code: Int = 3013, message: String, data: UnsuitableOutputReferenceData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - ScriptExecutionFailure Union Type

/// Union type representing all possible ScriptExecutionFailure types
public enum ScriptExecutionFailureType: JSONSerializable {
    case invalidRedeemerPointers(ScriptExecutionFailureInvalidRedeemerPointers)
    case validationFailure(ScriptExecutionFailureValidationFailure)
    case unsuitableOutputReference(ScriptExecutionFailureUnsuitableOutputReference)
    case extraneousRedeemers(SubmitTransactionFailureExtraneousRedeemers)
    case missingDatums(SubmitTransactionFailureMissingDatums)
    case unknownOutputReference(SubmitTransactionFailureUnknownOutputReference)
    case missingCostModels(SubmitTransactionFailureMissingCostModels)
    case executionBudgetOutOfBounds(SubmitTransactionFailureExecutionBudgetOutOfBounds)
    
    enum CodingKeys: String, CodingKey {
        case code
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let code = try container.decode(Int.self, forKey: .code)
        
        switch code {
        case 3011:
            self = .invalidRedeemerPointers(try ScriptExecutionFailureInvalidRedeemerPointers.init(from: decoder))
        case 3012:
            self = .validationFailure(try ScriptExecutionFailureValidationFailure.init(from: decoder))
        case 3013:
            self = .unsuitableOutputReference(try ScriptExecutionFailureUnsuitableOutputReference.init(from: decoder))
        case 3110:
            self = .extraneousRedeemers(try SubmitTransactionFailureExtraneousRedeemers.init(from: decoder))
        case 3111:
            self = .missingDatums(try SubmitTransactionFailureMissingDatums.init(from: decoder))
        case 3115:
            self = .missingCostModels(try SubmitTransactionFailureMissingCostModels.init(from: decoder))
        case 3117:
            self = .unknownOutputReference(try SubmitTransactionFailureUnknownOutputReference.init(from: decoder))
        case 3161:
            self = .executionBudgetOutOfBounds(try SubmitTransactionFailureExecutionBudgetOutOfBounds.init(from: decoder))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Unknown ScriptExecutionFailure code: \(code)"
            ))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .invalidRedeemerPointers(let failure):
            try failure.encode(to: encoder)
        case .validationFailure(let failure):
            try failure.encode(to: encoder)
        case .unsuitableOutputReference(let failure):
            try failure.encode(to: encoder)
        case .extraneousRedeemers(let failure):
            try failure.encode(to: encoder)
        case .missingDatums(let failure):
            try failure.encode(to: encoder)
        case .unknownOutputReference(let failure):
            try failure.encode(to: encoder)
        case .missingCostModels(let failure):
            try failure.encode(to: encoder)
        case .executionBudgetOutOfBounds(let failure):
            try failure.encode(to: encoder)
        }
    }
}
