import Foundation

// MARK: - InputSource
/// How inputs are consumed from the UTxO, either from inputs or by script validation via collaterals
public enum InputSource: String, Codable, Sendable, Equatable, Hashable {
    case inputs
    case collaterals
}

// MARK: - Signatory
/// A transaction signatory
public struct Signatory: Codable, Sendable, Equatable, Hashable {
    public let signature: String
    public let key: String
    
    public init(signature: String, key: String) {
        self.signature = signature
        self.key = key
    }
}

// MARK: - SimpleDatum
/// A simplified datum for basic transaction data
public struct SimpleDatum: Codable, Sendable, Equatable, Hashable {
    public let cbor: String?
    
    public init(cbor: String? = nil) {
        self.cbor = cbor
    }
}

// MARK: - SimpleRedeemer
/// A simplified redeemer for script validation
public struct SimpleRedeemer: Codable, Sendable, Equatable, Hashable {
    public let validator: String // RedeemerPointer
    public let datum: SimpleDatum
    
    public init(validator: String, datum: SimpleDatum) {
        self.validator = validator
        self.datum = datum
    }
}

// MARK: - Transaction
/// A complete transaction (simplified for NextTransaction responses)
public struct Transaction: Codable, Sendable, Equatable, Hashable {
    public let id: TransactionId
    public let spends: InputSource?
    public let inputs: [TransactionOutputReference]?
    public let outputs: [TransactionOutput]?
    public let signatories: [Signatory]?
    public let cbor: String?
    
    public init(
        id: TransactionId,
        spends: InputSource? = nil,
        inputs: [TransactionOutputReference]? = nil,
        outputs: [TransactionOutput]? = nil,
        signatories: [Signatory]? = nil,
        cbor: String? = nil
    ) {
        self.id = id
        self.spends = spends
        self.inputs = inputs
        self.outputs = outputs
        self.signatories = signatories
        self.cbor = cbor
    }
}

// MARK: - TransactionIdOnly
/// Simple transaction representation with only an ID
public struct TransactionIdOnly: Codable, Sendable, Equatable, Hashable {
    public let id: TransactionId
    
    public init(id: TransactionId) {
        self.id = id
    }
}

// MARK: - NextTransactionResult
/// Result type for NextTransaction response that can be either a transaction ID, full transaction, or null
public enum NextTransactionResult: Codable, Sendable, Equatable, Hashable {
    case transactionId(TransactionIdOnly)
    case fullTransaction(Transaction)
    case noMoreTransactions
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .noMoreTransactions
        } else {
            // Try to decode as a simple JSON first
            if let dict = try? container.decode([String: String].self),
               let id = dict["id"], dict.count == 1 {
                // Only has an ID field
                let idOnly = TransactionIdOnly(id: id)
                self = .transactionId(idOnly)
            } else {
                // Try to decode as full transaction
                let transaction = try Transaction(from: decoder)
                self = .fullTransaction(transaction)
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .transactionId(let idOnly):
            try container.encode(idOnly)
        case .fullTransaction(let transaction):
            try container.encode(transaction)
        case .noMoreTransactions:
            try container.encodeNil()
        }
    }
}
