import Foundation

// MARK: - Address
/// A Cardano address (either legacy format or new format)
public struct Address: Codable, Sendable, Equatable, Hashable {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - Value
/// A multi-asset value (Ada and native tokens)
public struct Value: Codable, Sendable, Equatable, Hashable {
    public let ada: Ada
    public let assets: [String: [String: Int64]]?
    
    public init(ada: Ada, assets: [String: [String: Int64]]? = nil) {
        self.ada = ada
        self.assets = assets
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ada = try container.decode(Ada.self, forKey: .ada)
        
        // Decode additional properties as assets
        var assetsDict: [String: [String: Int64]] = [:]
        for key in container.allKeys {
            if key.stringValue != "ada" {
                let assetMap = try container.decode([String: Int64].self, forKey: key)
                assetsDict[key.stringValue] = assetMap
            }
        }
        
        self.assets = assetsDict.isEmpty ? nil : assetsDict
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ada, forKey: .ada)
        
        // Encode assets as additional properties
        if let assets = assets {
            for (policyId, assetMap) in assets {
                if let key = CodingKeys(stringValue: policyId) {
                    try container.encode(assetMap, forKey: key)
                }
            }
        }
    }
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
        
        static let ada = CodingKeys(stringValue: "ada")!
    }
}

// MARK: - Script
/// A script (native or Plutus)
public enum Script: Codable, Sendable, Equatable, Hashable {
    case native(NativeScript)
    case plutus(PlutusScript)
    
    public struct NativeScript: Codable, Sendable, Equatable, Hashable {
        public let language: String
        public let json: String
        public let cbor: String?
        
        public init(language: String = "native", json: String, cbor: String? = nil) {
            self.language = language
            self.json = json
            self.cbor = cbor
        }
    }
    
    public struct PlutusScript: Codable, Sendable, Equatable, Hashable {
        public let language: String
        public let cbor: String
        
        public init(language: String, cbor: String) {
            self.language = language
            self.cbor = cbor
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let language = try container.decode(String.self, forKey: .language)
        
        if language == "native" {
            let script = try NativeScript(from: decoder)
            self = .native(script)
        } else {
            let script = try PlutusScript(from: decoder)
            self = .plutus(script)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .native(let script):
            try script.encode(to: encoder)
        case .plutus(let script):
            try script.encode(to: encoder)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case language
    }
}

// MARK: - TransactionOutputReference
/// Reference to a transaction output
public struct TransactionOutputReference: Codable, Sendable, Equatable, Hashable {
    public let transaction: TransactionReference
    public let index: UInt64
    
    public init(transaction: TransactionReference, index: UInt64) {
        self.transaction = transaction
        self.index = index
    }
    
    public struct TransactionReference: Codable, Sendable, Equatable, Hashable {
        public let id: String
        
        public init(id: String) {
            self.id = id
        }
    }
}

// MARK: - TransactionOutput
/// A transaction output
public struct TransactionOutput: Codable, Sendable, Equatable, Hashable {
    public let address: Address
    public let value: Value
    public let datumHash: String?
    public let datum: String?
    public let script: Script?
    
    public init(
        address: Address,
        value: Value,
        datumHash: String? = nil,
        datum: String? = nil,
        script: Script? = nil
    ) {
        self.address = address
        self.value = value
        self.datumHash = datumHash
        self.datum = datum
        self.script = script
    }
}

// MARK: - Utxo
/// UTXO entry combining reference and output information
public struct UtxoEntry: Codable, Sendable, Equatable, Hashable {
    public let transaction: TransactionOutputReference.TransactionReference
    public let index: UInt32
    public let address: Address
    public let value: Value
    public let datumHash: String?
    public let datum: String?
    public let script: Script?
    
    public init(
        transaction: TransactionOutputReference.TransactionReference,
        index: UInt32,
        address: Address,
        value: Value,
        datumHash: String? = nil,
        datum: String? = nil,
        script: Script? = nil
    ) {
        self.transaction = transaction
        self.index = index
        self.address = address
        self.value = value
        self.datumHash = datumHash
        self.datum = datum
        self.script = script
    }
}

// MARK: - Utxo Array
/// Array of UTXO entries
public typealias Utxo = [UtxoEntry]
public typealias PolicyId = DigestBlake2b224

public enum ScriptPurpose: JSONSerializable {
    case spend(Spend)
    case mint(Mint)
    case publish(Publish)
    case withdraw(Withdraw)
    case propose(Propose)
    case vote(Vote)
    
    public struct Spend: JSONSerializable {
        public let purpose: String
        public let outputReference: TransactionOutputReference
        
        public init(outputReference: TransactionOutputReference, purpose: String = "spend") {
            self.outputReference = outputReference
            self.purpose = purpose
        }
    }
    
    public struct Mint: JSONSerializable {
        public let purpose: String
        public let policy: PolicyId
        
        public init(policy: PolicyId, purpose: String = "publish") {
            self.policy = policy
            self.purpose = purpose
        }
    }
    
    public struct Publish: JSONSerializable {
        public let purpose: String
        public let policy: PolicyId
        
        public init(policy: PolicyId, purpose: String = "mint") {
            self.policy = policy
            self.purpose = purpose
        }
    }
    
    public struct Propose: JSONSerializable {
        public let purpose: String
        public let proposal: GovernanceProposal
        
        public init(proposal: GovernanceProposal, purpose: String = "propose") {
            self.proposal = proposal
            self.purpose = purpose
        }
    }
    
    public struct Vote: JSONSerializable {
        public let purpose: String
        public let issuer: GovernanceVoter
        
        public init(issuer: GovernanceVoter, purpose: String = "vote") {
            self.issuer = issuer
            self.purpose = purpose
        }
    }
    
    public struct Withdraw: JSONSerializable {
        public let purpose: String
        public let rewardAccount: RewardAccount
        
        public init(rewardAccount: RewardAccount, purpose: String = "withdraw") {
            self.rewardAccount = rewardAccount
            self.purpose = purpose
        }
    }
}

public enum Language: String, JSONSerializable {
    case plutusV1 = "plutus:v1"
    case plutusV2 = "plutus:v2"
    case plutusV3 = "plutus:v3"
}

public struct ValidityInterval: JSONSerializable {
    public let invalidBefore: Slot?
    public let invalidAfter: Slot?
}

public struct RedeemerPointer: JSONSerializable {
    public let purpose: RedeemerPurpose
    public let index: UInt64
}

public enum RedeemerPurpose: String, JSONSerializable {
    case spend
    case mint
    case publish
    case withdraw
    case vote
    case propose
}
