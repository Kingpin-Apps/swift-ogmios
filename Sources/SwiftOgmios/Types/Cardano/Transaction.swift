import Foundation

// MARK: - InputSource
/// How inputs are consumed from the UTxO, either from inputs or by script validation via collaterals
public enum InputSource: String, Codable, Sendable, Equatable, Hashable {
    case inputs
    case collaterals
}

// MARK: - Signatory
/// A signatory (EdDSA) for the transaction. The fields 'chainCode' and 'addressAttributes' are only present on bootstrap signatures (when spending from a Byron/Bootstrap address).
public struct Signatory: Codable, Sendable, Equatable, Hashable {
    /// An Ed25519 verification key
    public let key: VerificationKey
    /// An EdDSA signature
    public let signature: Signature
    /// An Ed25519-BIP32 chain-code for key deriviation (only present on bootstrap signatures)
    public let chainCode: ChainCode?
    /// Extra attributes carried by Byron addresses (network magic and/or HD payload) (only present on bootstrap signatures)
    public let addressAttributes: AddressAttributes?
    
    public init(key: VerificationKey, signature: Signature, chainCode: ChainCode? = nil, addressAttributes: AddressAttributes? = nil) {
        self.key = key
        self.signature = signature
        self.chainCode = chainCode
        self.addressAttributes = addressAttributes
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

// MARK: - Treasury
/// Treasury objects for the transaction
public struct Treasury: Codable, Sendable, Equatable, Hashable {
    /// Value in the treasury
    public let value: ValueAdaOnly?
    /// Donation value
    public let donation: ValueAdaOnly?
    
    public init(value: ValueAdaOnly? = nil, donation: ValueAdaOnly? = nil) {
        self.value = value
        self.donation = donation
    }
}

// MARK: - Transaction
/// A complete transaction as defined in the Cardano JSON schema
public struct Transaction: Codable, Sendable, Equatable, Hashable {
    /// Transaction Id (A Blake2b 32-byte hash digest of a transaction body) - REQUIRED
    public let id: TransactionId
    /// Input source - how inputs are consumed (by inputs or collaterals) - REQUIRED
    public let spends: InputSource
    /// Array of transaction input references - REQUIRED
    public let inputs: [TransactionOutputReference]
    /// Optional array of reference inputs (UTxO outputs referenced but not spent)
    public let references: [TransactionOutputReference]?
    /// Optional collaterals used for script validation
    public let collaterals: [TransactionOutputReference]?
    /// Total collateral value
    public let totalCollateral: ValueAdaOnly?
    /// Return output for collateral
    public let collateralReturn: TransactionOutput?
    /// Array of transaction outputs - REQUIRED
    public let outputs: [TransactionOutput]
    /// Certificates involved in this transaction
    public let certificates: [Certificate]?
    /// Withdrawals included in the transaction
    public let withdrawals: Withdrawals?
    /// Transaction fee
    public let fee: ValueAdaOnly?
    /// Validity interval defining before and after which slots the transaction is invalid
    public let validityInterval: ValidityInterval?
    /// Minted assets
    public let mint: Assets?
    /// Network identifier (A network target, as defined since the Shelley era)
    public let network: Network?
    /// Script integrity hash (for scripts validation)
    public let scriptIntegrityHash: DigestBlake2b256?
    /// Required extra signatories (hashes)
    public let requiredExtraSignatories: [DigestBlake2b224]?
    /// Required extra scripts (hashes)
    public let requiredExtraScripts: [DigestBlake2b224]?
    /// Governance proposals included
    public let proposals: [GovernanceProposal]?
    /// Governance votes included
    public let votes: [GovernanceVote]?
    /// Metadata associated with the transaction
    public let metadata: Metadata?
    /// Signatories for this transaction - REQUIRED
    public let signatories: [Signatory]
    /// Scripts included in the transaction (keyed by hex string)
    public let scripts: [String: Script]?
    /// Datums indexed by hash (keyed by hex string)
    public let datums: [String: Datum]?
    /// Redeemers used for script validation
    public let redeemers: [Redeemer]?
    /// Treasury objects for the transaction
    public let treasury: Treasury?
    /// The raw serialized (CBOR) transaction, as found on-chain. Use --include-transaction-cbor to ALWAYS include the 'cbor' field. Omitted otherwise.
    public let cbor: String?
    
    public init(
        id: TransactionId,
        spends: InputSource,
        inputs: [TransactionOutputReference],
        outputs: [TransactionOutput],
        signatories: [Signatory],
        references: [TransactionOutputReference]? = nil,
        collaterals: [TransactionOutputReference]? = nil,
        totalCollateral: ValueAdaOnly? = nil,
        collateralReturn: TransactionOutput? = nil,
        certificates: [Certificate]? = nil,
        withdrawals: Withdrawals? = nil,
        fee: ValueAdaOnly? = nil,
        validityInterval: ValidityInterval? = nil,
        mint: Assets? = nil,
        network: Network? = nil,
        scriptIntegrityHash: DigestBlake2b256? = nil,
        requiredExtraSignatories: [DigestBlake2b224]? = nil,
        requiredExtraScripts: [DigestBlake2b224]? = nil,
        proposals: [GovernanceProposal]? = nil,
        votes: [GovernanceVote]? = nil,
        metadata: Metadata? = nil,
        scripts: [String: Script]? = nil,
        datums: [String: Datum]? = nil,
        redeemers: [Redeemer]? = nil,
        treasury: Treasury? = nil,
        cbor: String? = nil
    ) {
        self.id = id
        self.spends = spends
        self.inputs = inputs
        self.outputs = outputs
        self.signatories = signatories
        self.references = references
        self.collaterals = collaterals
        self.totalCollateral = totalCollateral
        self.collateralReturn = collateralReturn
        self.certificates = certificates
        self.withdrawals = withdrawals
        self.fee = fee
        self.validityInterval = validityInterval
        self.mint = mint
        self.network = network
        self.scriptIntegrityHash = scriptIntegrityHash
        self.requiredExtraSignatories = requiredExtraSignatories
        self.requiredExtraScripts = requiredExtraScripts
        self.proposals = proposals
        self.votes = votes
        self.metadata = metadata
        self.scripts = scripts
        self.datums = datums
        self.redeemers = redeemers
        self.treasury = treasury
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
