import Foundation

// MARK: - Block Enum

public enum Block: JSONSerializable {
    case ebb(EBB)
    case bft(BFT)
    case praos(Praos)
    
    // MARK: - EBB Block (Epoch Boundary Block)
    
    /// Epoch Boundary Block (Byron era)
    public struct EBB: JSONSerializable {
        public let type: String // Always "ebb"
        public let era: String // Always "byron"
        public let id: DigestBlake2b256
        public let ancestor: DigestBlake2b256
        public let height: BlockHeight
        
        public init(
            id: DigestBlake2b256,
            ancestor: DigestBlake2b256,
            height: BlockHeight
        ) {
            self.type = "ebb"
            self.era = "byron"
            self.id = id
            self.ancestor = ancestor
            self.height = height
        }
        
        private enum CodingKeys: String, CodingKey {
            case type, era, id, ancestor, height
        }
    }
    
    // MARK: - BFT Block (Byzantine Fault Tolerant)
    
    /// BFT Block (Byron era)
    public struct BFT: JSONSerializable {
        public let type: String // Always "bft"
        public let era: String // Always "byron"
        public let id: DigestBlake2b256
        public let ancestor: DigestBlake2b256
        public let height: BlockHeight
        public let slot: Slot
        public let size: NumberOfBytes
        public let transactions: [Transaction]?
        public let operationalCertificates: [BlockBootstrapOperationalCertificate]?
        public let `protocol`: BFTProtocol
        public let issuer: BFTIssuer
        public let delegate: BFTDelegate
        
        public struct BFTProtocol: JSONSerializable {
            public let id: BootstrapProtocolId
            public let version: ProtocolVersion
            public let software: SoftwareVersion
            public let update: BootstrapProtocolUpdate?
            
            public init(id: BootstrapProtocolId, version: ProtocolVersion, software: SoftwareVersion, update: BootstrapProtocolUpdate? = nil) {
                self.id = id
                self.version = version
                self.software = software
                self.update = update
            }
        }
        
        public struct BFTIssuer: JSONSerializable {
            public let verificationKey: ExtendedVerificationKey
            
            public init(verificationKey: ExtendedVerificationKey) {
                self.verificationKey = verificationKey
            }
        }
        
        public struct BFTDelegate: JSONSerializable {
            public let verificationKey: ExtendedVerificationKey
            
            public init(verificationKey: ExtendedVerificationKey) {
                self.verificationKey = verificationKey
            }
        }
        
        public init(
            id: DigestBlake2b256,
            ancestor: DigestBlake2b256,
            height: BlockHeight,
            slot: Slot,
            size: NumberOfBytes,
            transactions: [Transaction]? = nil,
            operationalCertificates: [BlockBootstrapOperationalCertificate]? = nil,
            protocol: BFTProtocol,
            issuer: BFTIssuer,
            delegate: BFTDelegate
        ) {
            self.type = "bft"
            self.era = "byron"
            self.id = id
            self.ancestor = ancestor
            self.height = height
            self.slot = slot
            self.size = size
            self.transactions = transactions
            self.operationalCertificates = operationalCertificates
            self.`protocol` = `protocol`
            self.issuer = issuer
            self.delegate = delegate
        }
        
        private enum CodingKeys: String, CodingKey {
            case type, era, id, ancestor, height, slot, size, transactions, operationalCertificates
            case `protocol` = "protocol"
            case issuer, delegate
        }
    }
    
    // MARK: - Praos Block
    
    /// Praos Block (Shelley+ eras)
    public struct Praos: JSONSerializable {
        public let type: String // Always "praos"
        public let era: Era // shelley, allegra, mary, alonzo, babbage, conway
        public let id: DigestBlake2b256
        public let ancestor: PraosAncestor
        public let nonce: CertifiedVrf?
        public let height: BlockHeight
        public let size: NumberOfBytes
        public let slot: Slot
        public let transactions: [Transaction]?
        public let `protocol`: PraosProtocol
        public let issuer: PraosIssuer
        
        /// Praos ancestor can be either a hash or "genesis"
        public enum PraosAncestor: JSONSerializable {
            case hash(DigestBlake2b256)
            case genesis
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let hashString = try? container.decode(String.self) {
                    if hashString == "genesis" {
                        self = .genesis
                    } else {
                        self = .hash(try DigestBlake2b256(hashString))
                    }
                } else {
                    throw DecodingError.typeMismatch(
                        PraosAncestor.self,
                        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected string")
                    )
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                    case .hash(let hash):
                        try container.encode(hash.value)
                    case .genesis:
                        try container.encode("genesis")
                }
            }
        }
        
        public struct PraosProtocol: JSONSerializable {
            public let version: ProtocolVersion
            
            public init(version: ProtocolVersion) {
                self.version = version
            }
        }
        
        public struct PraosIssuer: JSONSerializable {
            public let verificationKey: VerificationKey
            public let vrfVerificationKey: VerificationKey
            public let operationalCertificate: OperationalCertificate
            public let leaderValue: CertifiedVrf
            
            public init(
                verificationKey: VerificationKey,
                vrfVerificationKey: VerificationKey,
                operationalCertificate: OperationalCertificate,
                leaderValue: CertifiedVrf
            ) {
                self.verificationKey = verificationKey
                self.vrfVerificationKey = vrfVerificationKey
                self.operationalCertificate = operationalCertificate
                self.leaderValue = leaderValue
            }
        }
        
        public init(
            era: Era,
            id: DigestBlake2b256,
            ancestor: PraosAncestor,
            nonce: CertifiedVrf? = nil,
            height: BlockHeight,
            size: NumberOfBytes,
            slot: Slot,
            transactions: [Transaction]? = nil,
            protocol: PraosProtocol,
            issuer: PraosIssuer
        ) {
            self.type = "praos"
            self.era = era
            self.id = id
            self.ancestor = ancestor
            self.nonce = nonce
            self.height = height
            self.size = size
            self.slot = slot
            self.transactions = transactions
            self.`protocol` = `protocol`
            self.issuer = issuer
        }
        
        private enum CodingKeys: String, CodingKey {
            case type, era, id, ancestor, nonce, height, size, slot, transactions
            case `protocol` = "protocol"
            case issuer
        }
    }
    

    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "ebb":
            let ebb = try EBB(from: decoder)
            self = .ebb(ebb)
        case "bft":
            let bft = try BFT(from: decoder)
            self = .bft(bft)
        case "praos":
            let praos = try Praos(from: decoder)
            self = .praos(praos)
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Unknown block type: \(type)"
            ))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .ebb(let ebb):
            try ebb.encode(to: encoder)
        case .bft(let bft):
            try bft.encode(to: encoder)
        case .praos(let praos):
            try praos.encode(to: encoder)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
}

// MARK: - Supporting Types

/// Software version information
public struct SoftwareVersion: JSONSerializable {
    public let appName: String
    public let number: UInt32
    
    public init(appName: String, number: UInt32) {
        self.appName = appName
        self.number = number
    }
}

/// Bootstrap protocol ID
public typealias BootstrapProtocolId = UInt32

/// Extended verification key (Byron era)
public typealias ExtendedVerificationKey = String

/// KES verification key
public typealias KesVerificationKey = String

/// VRF proof with certification
public struct CertifiedVrf: JSONSerializable {
    public let output: String
    public let proof: String
    
    public init(output: String, proof: String) {
        self.output = output
        self.proof = proof
    }
}

/// Operational certificate for block production
public struct OperationalCertificate: JSONSerializable {
    public let count: UInt64
    public let sigma: String? // Signature
    public let kes: KesInfo
    
    public struct KesInfo: JSONSerializable {
        public let period: UInt64
        public let verificationKey: KesVerificationKey
        
        public init(period: UInt64, verificationKey: KesVerificationKey) {
            self.period = period
            self.verificationKey = verificationKey
        }
    }
    
    public init(count: UInt64, sigma: String? = nil, kes: KesInfo) {
        self.count = count
        self.sigma = sigma
        self.kes = kes
    }
}

/// Bootstrap operational certificate (Byron era delegation) for blocks
public struct BlockBootstrapOperationalCertificate: JSONSerializable {
    public let issuer: IssuerInfo
    public let delegate: DelegateInfo
    
    public struct IssuerInfo: JSONSerializable {
        public let verificationKey: VerificationKey
        
        public init(verificationKey: VerificationKey) {
            self.verificationKey = verificationKey
        }
    }
    
    public struct DelegateInfo: JSONSerializable {
        public let verificationKey: VerificationKey
        
        public init(verificationKey: VerificationKey) {
            self.verificationKey = verificationKey
        }
    }
    
    public init(issuer: IssuerInfo, delegate: DelegateInfo) {
        self.issuer = issuer
        self.delegate = delegate
    }
}

/// Bootstrap protocol update (Byron era)
public struct BootstrapProtocolUpdate: JSONSerializable {
    public let proposal: ProtocolUpdateProposal?
    public let votes: [BootstrapVote]
    
    public struct ProtocolUpdateProposal: JSONSerializable {
        public let version: ProtocolVersion
        public let software: SoftwareVersion
        public let parameters: BootstrapProtocolParameters
        public let metadata: [String: String]
        
        public init(version: ProtocolVersion, software: SoftwareVersion, parameters: BootstrapProtocolParameters, metadata: [String: String]) {
            self.version = version
            self.software = software
            self.parameters = parameters
            self.metadata = metadata
        }
    }
    
    public init(proposal: ProtocolUpdateProposal? = nil, votes: [BootstrapVote]) {
        self.proposal = proposal
        self.votes = votes
    }
}

/// Bootstrap vote (Byron era)
public struct BootstrapVote: JSONSerializable {
    // Implementation depends on Byron era voting structure
    // This is a simplified version
    public let voter: String
    public let decision: Bool
    
    public init(voter: String, decision: Bool) {
        self.voter = voter
        self.decision = decision
    }
}

/// Bootstrap protocol parameters (Byron era)
public struct BootstrapProtocolParameters: JSONSerializable {
    public let heavyDelegationThreshold: Ratio?
    public let maxBlockBodySize: NumberOfBytes?
    public let maxBlockHeaderSize: NumberOfBytes?
    public let maxUpdateProposalSize: NumberOfBytes?
    public let maxTransactionSize: NumberOfBytes?
    public let multiPartyComputationThreshold: Ratio?
    public let scriptVersion: UInt64?
    public let slotDuration: UInt64?
    public let unlockStakeEpoch: UInt64?
    public let updateProposalThreshold: Ratio?
    public let updateProposalTimeToLive: UInt64?
    public let updateVoteThreshold: Ratio?
    public let softForkInitThreshold: Ratio?
    public let softForkMinThreshold: Ratio?
    public let softForkDecrementThreshold: Ratio?
    public let minFeeCoefficient: UInt64?
    public let minFeeConstant: ValueAdaOnly?
    
    public init(
        heavyDelegationThreshold: Ratio? = nil,
        maxBlockBodySize: NumberOfBytes? = nil,
        maxBlockHeaderSize: NumberOfBytes? = nil,
        maxUpdateProposalSize: NumberOfBytes? = nil,
        maxTransactionSize: NumberOfBytes? = nil,
        multiPartyComputationThreshold: Ratio? = nil,
        scriptVersion: UInt64? = nil,
        slotDuration: UInt64? = nil,
        unlockStakeEpoch: UInt64? = nil,
        updateProposalThreshold: Ratio? = nil,
        updateProposalTimeToLive: UInt64? = nil,
        updateVoteThreshold: Ratio? = nil,
        softForkInitThreshold: Ratio? = nil,
        softForkMinThreshold: Ratio? = nil,
        softForkDecrementThreshold: Ratio? = nil,
        minFeeCoefficient: UInt64? = nil,
        minFeeConstant: ValueAdaOnly? = nil
    ) {
        self.heavyDelegationThreshold = heavyDelegationThreshold
        self.maxBlockBodySize = maxBlockBodySize
        self.maxBlockHeaderSize = maxBlockHeaderSize
        self.maxUpdateProposalSize = maxUpdateProposalSize
        self.maxTransactionSize = maxTransactionSize
        self.multiPartyComputationThreshold = multiPartyComputationThreshold
        self.scriptVersion = scriptVersion
        self.slotDuration = slotDuration
        self.unlockStakeEpoch = unlockStakeEpoch
        self.updateProposalThreshold = updateProposalThreshold
        self.updateProposalTimeToLive = updateProposalTimeToLive
        self.updateVoteThreshold = updateVoteThreshold
        self.softForkInitThreshold = softForkInitThreshold
        self.softForkMinThreshold = softForkMinThreshold
        self.softForkDecrementThreshold = softForkDecrementThreshold
        self.minFeeCoefficient = minFeeCoefficient
        self.minFeeConstant = minFeeConstant
    }
}
