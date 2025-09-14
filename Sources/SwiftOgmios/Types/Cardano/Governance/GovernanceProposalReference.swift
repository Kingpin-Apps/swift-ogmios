
public struct GovernanceProposal: JSONSerializable {
    public let deposit: ValueAdaOnly?
    public let returnAccount: RewardAccount?
    public let metadata: Anchor?
    public let action: GovernanceAction
}

public struct GovernanceProposalReference: JSONSerializable {
    public let transaction: TransactionIdWrapper
    public let index: UInt32
}

public struct GovernanceProposalState: JSONSerializable {
    public let proposal: GovernanceProposalReference
    public let deposit: ValueAdaOnly
    public let returnAccount: RewardAccount
    public let metadata: Anchor
    public let action: GovernanceAction
    public let since: EpochWrapper
    public let until: EpochWrapper
    public let votes: [GovernanceVote]
}
