
public struct GovernanceProposalReference: Codable, Sendable {
    public let transaction: TransactionId
    public let index: UInt32
}

public struct GovernanceProposalState: Codable, Sendable {
    public let proposal: GovernanceProposalReference
    public let deposit: ValueAdaOnly
    public let returnAccount: RewardAccount
    public let metadata: Anchor
    public let action: GovernanceAction
    public let since: EpochWrapper
    public let until: EpochWrapper
    public let votes: [GovernanceVote]
}

///// A Blake2b 32-byte hash digest of a transaction body
public struct TransactionId: Codable, Sendable {
    public let id: String
    
    public init(_ id: String) throws {
        guard id.count == 64 else {
            throw OgmiosError
                .invalidLength(
                    "TransactionId must be exactly 64 characters, got \(id.count)"
                )
        }
        
        self.id = id
    }
}
