// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcomeProperties = try? newJSONDecoder().decode(WelcomeProperties.self, from: jsonData)

import Foundation

// MARK: - WelcomeProperties
public struct WelcomeProperties: Codable, Sendable {
    public let findIntersection: AcquireLedgerState
    public let findIntersectionResponse: FindIntersectionResponse
    public let nextBlock, nextBlockResponse, submitTransaction: AcquireLedgerState
    public let submitTransactionResponse: SubmitTransactionResponse
    public let evaluateTransaction: AcquireLedgerState
    public let evaluateTransactionResponse: EvaluateTransactionResponse
    public let acquireLedgerState: AcquireLedgerState
    public let acquireLedgerStateFailure: AcquireLedgerStateFailure
    public let acquireLedgerStateResponse: Response
    public let releaseLedgerState: AcquireLedgerState
    public let releaseLedgerStateResponse: QueryNetworkStartTimeResponse
    public let queryLedgerStateEraMismatch, queryLedgerStateUnavailableInCurrentEra, queryLedgerStateAcquiredExpired: AcquireLedgerStateFailure
    public let queryLedgerStateConstitution: AcquireLedgerState
    public let queryLedgerStateConstitutionResponse: Response
    public let queryLedgerStateConstitutionalCommittee: AcquireLedgerState
    public let queryLedgerStateConstitutionalCommitteeResponse: QueryLedgerStateResponse
    public let queryLedgerStateDelegateRepresentatives: AcquireLedgerState
    public let queryLedgerStateDelegateRepresentativesResponse: QueryLedgerStateResponse
    public let queryLedgerStateDump: AcquireLedgerState
    public let queryLedgerStateDumpResponse: Response
    public let queryLedgerStateEpoch: AcquireLedgerState
    public let queryLedgerStateEpochResponse: Response
    public let queryLedgerStateEraStart: AcquireLedgerState
    public let queryLedgerStateEraStartResponse: Response
    public let queryLedgerStateEraSummaries: AcquireLedgerState
    public let queryLedgerStateEraSummariesResponse: QueryLedgerStateResponse
    public let queryLedgerStateGovernanceProposals: AcquireLedgerState
    public let queryLedgerStateGovernanceProposalsResponse: QueryLedgerStateResponse
    public let queryLedgerStateLiveStakeDistribution, queryLedgerStateNonces: AcquireLedgerState
    public let queryLedgerStateNoncesResponse: Response
    public let queryLedgerStateOperationalCertificates: AcquireLedgerState
    public let queryLedgerStateOperationalCertificatesResponse, queryLedgerStateLiveStakeDistributionResponse: Response
    public let queryLedgerStateProjectedRewards: AcquireLedgerState
    public let queryLedgerStateProjectedRewardsResponse: Response
    public let queryLedgerStateProposedProtocolParameters: AcquireLedgerState
    public let queryLedgerStateProposedProtocolParametersResponse: QueryLedgerStateResponse
    public let queryLedgerStateProtocolParameters: AcquireLedgerState
    public let queryLedgerStateProtocolParametersResponse: Response
    public let queryLedgerStateRewardAccountSummaries: AcquireLedgerState
    public let queryLedgerStateRewardAccountSummariesResponse: QueryLedgerStateResponse
    public let queryLedgerStateRewardsProvenance: AcquireLedgerState
    public let queryLedgerStateRewardsProvenanceResponse: Response
    public let queryLedgerStateStakePoolsPerformances: AcquireLedgerState
    public let queryLedgerStateStakePoolsPerformancesResponse: Response
    public let queryLedgerStateStakePools: AcquireLedgerState
    public let queryLedgerStateStakePoolsResponse: QueryLedgerStateResponse
    public let queryLedgerStateTip: AcquireLedgerState
    public let queryLedgerStateTipResponse: Response
    public let queryLedgerStateTreasuryAndReserves: AcquireLedgerState
    public let queryLedgerStateTreasuryAndReservesResponse: QueryLedgerStateResponse
    public let queryLedgerStateUtxo: AcquireLedgerState
    public let queryLedgerStateUtxoResponse: Response
    public let queryNetworkBlockHeight: AcquireLedgerState
    public let queryNetworkBlockHeightResponse: AcquireLedgerStateFailure
    public let queryNetworkGenesisConfiguration: AcquireLedgerState
    public let queryNetworkGenesisConfigurationResponse, queryNetworkInvalidGenesis: AcquireLedgerStateFailure
    public let queryNetworkStartTime: AcquireLedgerState
    public let queryNetworkStartTimeResponse: QueryNetworkStartTimeResponse
    public let queryNetworkTip: AcquireLedgerState
    public let queryNetworkTipResponse: QueryNetworkStartTimeResponse
    public let acquireMempool, acquireMempoolResponse, nextTransaction: AcquireLedgerState
    public let mustAcquireMempoolFirst: AcquireLedgerStateFailure
    public let nextTransactionResponse: Response
    public let hasTransaction: AcquireLedgerState
    public let hasTransactionResponse: Response
    public let sizeOfMempool: AcquireLedgerState
    public let sizeOfMempoolResponse: Response
    public let releaseMempool: AcquireLedgerState
    public let releaseMempoolResponse: Response
    public let rpcError: RPCError

    public enum CodingKeys: String, CodingKey {
        case findIntersection = "FindIntersection"
        case findIntersectionResponse = "FindIntersectionResponse"
        case nextBlock = "NextBlock"
        case nextBlockResponse = "NextBlockResponse"
        case submitTransaction = "SubmitTransaction"
        case submitTransactionResponse = "SubmitTransactionResponse"
        case evaluateTransaction = "EvaluateTransaction"
        case evaluateTransactionResponse = "EvaluateTransactionResponse"
        case acquireLedgerState = "AcquireLedgerState"
        case acquireLedgerStateFailure = "AcquireLedgerStateFailure"
        case acquireLedgerStateResponse = "AcquireLedgerStateResponse"
        case releaseLedgerState = "ReleaseLedgerState"
        case releaseLedgerStateResponse = "ReleaseLedgerStateResponse"
        case queryLedgerStateEraMismatch = "QueryLedgerStateEraMismatch"
        case queryLedgerStateUnavailableInCurrentEra = "QueryLedgerStateUnavailableInCurrentEra"
        case queryLedgerStateAcquiredExpired = "QueryLedgerStateAcquiredExpired"
        case queryLedgerStateConstitution = "QueryLedgerStateConstitution"
        case queryLedgerStateConstitutionResponse = "QueryLedgerStateConstitutionResponse"
        case queryLedgerStateConstitutionalCommittee = "QueryLedgerStateConstitutionalCommittee"
        case queryLedgerStateConstitutionalCommitteeResponse = "QueryLedgerStateConstitutionalCommitteeResponse"
        case queryLedgerStateDelegateRepresentatives = "QueryLedgerStateDelegateRepresentatives"
        case queryLedgerStateDelegateRepresentativesResponse = "QueryLedgerStateDelegateRepresentativesResponse"
        case queryLedgerStateDump = "QueryLedgerStateDump"
        case queryLedgerStateDumpResponse = "QueryLedgerStateDumpResponse"
        case queryLedgerStateEpoch = "QueryLedgerStateEpoch"
        case queryLedgerStateEpochResponse = "QueryLedgerStateEpochResponse"
        case queryLedgerStateEraStart = "QueryLedgerStateEraStart"
        case queryLedgerStateEraStartResponse = "QueryLedgerStateEraStartResponse"
        case queryLedgerStateEraSummaries = "QueryLedgerStateEraSummaries"
        case queryLedgerStateEraSummariesResponse = "QueryLedgerStateEraSummariesResponse"
        case queryLedgerStateGovernanceProposals = "QueryLedgerStateGovernanceProposals"
        case queryLedgerStateGovernanceProposalsResponse = "QueryLedgerStateGovernanceProposalsResponse"
        case queryLedgerStateLiveStakeDistribution = "QueryLedgerStateLiveStakeDistribution"
        case queryLedgerStateNonces = "QueryLedgerStateNonces"
        case queryLedgerStateNoncesResponse = "QueryLedgerStateNoncesResponse"
        case queryLedgerStateOperationalCertificates = "QueryLedgerStateOperationalCertificates"
        case queryLedgerStateOperationalCertificatesResponse = "QueryLedgerStateOperationalCertificatesResponse"
        case queryLedgerStateLiveStakeDistributionResponse = "QueryLedgerStateLiveStakeDistributionResponse"
        case queryLedgerStateProjectedRewards = "QueryLedgerStateProjectedRewards"
        case queryLedgerStateProjectedRewardsResponse = "QueryLedgerStateProjectedRewardsResponse"
        case queryLedgerStateProposedProtocolParameters = "QueryLedgerStateProposedProtocolParameters"
        case queryLedgerStateProposedProtocolParametersResponse = "QueryLedgerStateProposedProtocolParametersResponse"
        case queryLedgerStateProtocolParameters = "QueryLedgerStateProtocolParameters"
        case queryLedgerStateProtocolParametersResponse = "QueryLedgerStateProtocolParametersResponse"
        case queryLedgerStateRewardAccountSummaries = "QueryLedgerStateRewardAccountSummaries"
        case queryLedgerStateRewardAccountSummariesResponse = "QueryLedgerStateRewardAccountSummariesResponse"
        case queryLedgerStateRewardsProvenance = "QueryLedgerStateRewardsProvenance"
        case queryLedgerStateRewardsProvenanceResponse = "QueryLedgerStateRewardsProvenanceResponse"
        case queryLedgerStateStakePoolsPerformances = "QueryLedgerStateStakePoolsPerformances"
        case queryLedgerStateStakePoolsPerformancesResponse = "QueryLedgerStateStakePoolsPerformancesResponse"
        case queryLedgerStateStakePools = "QueryLedgerStateStakePools"
        case queryLedgerStateStakePoolsResponse = "QueryLedgerStateStakePoolsResponse"
        case queryLedgerStateTip = "QueryLedgerStateTip"
        case queryLedgerStateTipResponse = "QueryLedgerStateTipResponse"
        case queryLedgerStateTreasuryAndReserves = "QueryLedgerStateTreasuryAndReserves"
        case queryLedgerStateTreasuryAndReservesResponse = "QueryLedgerStateTreasuryAndReservesResponse"
        case queryLedgerStateUtxo = "QueryLedgerStateUtxo"
        case queryLedgerStateUtxoResponse = "QueryLedgerStateUtxoResponse"
        case queryNetworkBlockHeight = "QueryNetworkBlockHeight"
        case queryNetworkBlockHeightResponse = "QueryNetworkBlockHeightResponse"
        case queryNetworkGenesisConfiguration = "QueryNetworkGenesisConfiguration"
        case queryNetworkGenesisConfigurationResponse = "QueryNetworkGenesisConfigurationResponse"
        case queryNetworkInvalidGenesis = "QueryNetworkInvalidGenesis"
        case queryNetworkStartTime = "QueryNetworkStartTime"
        case queryNetworkStartTimeResponse = "QueryNetworkStartTimeResponse"
        case queryNetworkTip = "QueryNetworkTip"
        case queryNetworkTipResponse = "QueryNetworkTipResponse"
        case acquireMempool = "AcquireMempool"
        case acquireMempoolResponse = "AcquireMempoolResponse"
        case nextTransaction = "NextTransaction"
        case mustAcquireMempoolFirst = "MustAcquireMempoolFirst"
        case nextTransactionResponse = "NextTransactionResponse"
        case hasTransaction = "HasTransaction"
        case hasTransactionResponse = "HasTransactionResponse"
        case sizeOfMempool = "SizeOfMempool"
        case sizeOfMempoolResponse = "SizeOfMempoolResponse"
        case releaseMempool = "ReleaseMempool"
        case releaseMempoolResponse = "ReleaseMempoolResponse"
        case rpcError = "RpcError"
    }

    public init(findIntersection: AcquireLedgerState, findIntersectionResponse: FindIntersectionResponse, nextBlock: AcquireLedgerState, nextBlockResponse: AcquireLedgerState, submitTransaction: AcquireLedgerState, submitTransactionResponse: SubmitTransactionResponse, evaluateTransaction: AcquireLedgerState, evaluateTransactionResponse: EvaluateTransactionResponse, acquireLedgerState: AcquireLedgerState, acquireLedgerStateFailure: AcquireLedgerStateFailure, acquireLedgerStateResponse: Response, releaseLedgerState: AcquireLedgerState, releaseLedgerStateResponse: QueryNetworkStartTimeResponse, queryLedgerStateEraMismatch: AcquireLedgerStateFailure, queryLedgerStateUnavailableInCurrentEra: AcquireLedgerStateFailure, queryLedgerStateAcquiredExpired: AcquireLedgerStateFailure, queryLedgerStateConstitution: AcquireLedgerState, queryLedgerStateConstitutionResponse: Response, queryLedgerStateConstitutionalCommittee: AcquireLedgerState, queryLedgerStateConstitutionalCommitteeResponse: QueryLedgerStateResponse, queryLedgerStateDelegateRepresentatives: AcquireLedgerState, queryLedgerStateDelegateRepresentativesResponse: QueryLedgerStateResponse, queryLedgerStateDump: AcquireLedgerState, queryLedgerStateDumpResponse: Response, queryLedgerStateEpoch: AcquireLedgerState, queryLedgerStateEpochResponse: Response, queryLedgerStateEraStart: AcquireLedgerState, queryLedgerStateEraStartResponse: Response, queryLedgerStateEraSummaries: AcquireLedgerState, queryLedgerStateEraSummariesResponse: QueryLedgerStateResponse, queryLedgerStateGovernanceProposals: AcquireLedgerState, queryLedgerStateGovernanceProposalsResponse: QueryLedgerStateResponse, queryLedgerStateLiveStakeDistribution: AcquireLedgerState, queryLedgerStateNonces: AcquireLedgerState, queryLedgerStateNoncesResponse: Response, queryLedgerStateOperationalCertificates: AcquireLedgerState, queryLedgerStateOperationalCertificatesResponse: Response, queryLedgerStateLiveStakeDistributionResponse: Response, queryLedgerStateProjectedRewards: AcquireLedgerState, queryLedgerStateProjectedRewardsResponse: Response, queryLedgerStateProposedProtocolParameters: AcquireLedgerState, queryLedgerStateProposedProtocolParametersResponse: QueryLedgerStateResponse, queryLedgerStateProtocolParameters: AcquireLedgerState, queryLedgerStateProtocolParametersResponse: Response, queryLedgerStateRewardAccountSummaries: AcquireLedgerState, queryLedgerStateRewardAccountSummariesResponse: QueryLedgerStateResponse, queryLedgerStateRewardsProvenance: AcquireLedgerState, queryLedgerStateRewardsProvenanceResponse: Response, queryLedgerStateStakePoolsPerformances: AcquireLedgerState, queryLedgerStateStakePoolsPerformancesResponse: Response, queryLedgerStateStakePools: AcquireLedgerState, queryLedgerStateStakePoolsResponse: QueryLedgerStateResponse, queryLedgerStateTip: AcquireLedgerState, queryLedgerStateTipResponse: Response, queryLedgerStateTreasuryAndReserves: AcquireLedgerState, queryLedgerStateTreasuryAndReservesResponse: QueryLedgerStateResponse, queryLedgerStateUtxo: AcquireLedgerState, queryLedgerStateUtxoResponse: Response, queryNetworkBlockHeight: AcquireLedgerState, queryNetworkBlockHeightResponse: AcquireLedgerStateFailure, queryNetworkGenesisConfiguration: AcquireLedgerState, queryNetworkGenesisConfigurationResponse: AcquireLedgerStateFailure, queryNetworkInvalidGenesis: AcquireLedgerStateFailure, queryNetworkStartTime: AcquireLedgerState, queryNetworkStartTimeResponse: QueryNetworkStartTimeResponse, queryNetworkTip: AcquireLedgerState, queryNetworkTipResponse: QueryNetworkStartTimeResponse, acquireMempool: AcquireLedgerState, acquireMempoolResponse: AcquireLedgerState, nextTransaction: AcquireLedgerState, mustAcquireMempoolFirst: AcquireLedgerStateFailure, nextTransactionResponse: Response, hasTransaction: AcquireLedgerState, hasTransactionResponse: Response, sizeOfMempool: AcquireLedgerState, sizeOfMempoolResponse: Response, releaseMempool: AcquireLedgerState, releaseMempoolResponse: Response, rpcError: RPCError) {
        self.findIntersection = findIntersection
        self.findIntersectionResponse = findIntersectionResponse
        self.nextBlock = nextBlock
        self.nextBlockResponse = nextBlockResponse
        self.submitTransaction = submitTransaction
        self.submitTransactionResponse = submitTransactionResponse
        self.evaluateTransaction = evaluateTransaction
        self.evaluateTransactionResponse = evaluateTransactionResponse
        self.acquireLedgerState = acquireLedgerState
        self.acquireLedgerStateFailure = acquireLedgerStateFailure
        self.acquireLedgerStateResponse = acquireLedgerStateResponse
        self.releaseLedgerState = releaseLedgerState
        self.releaseLedgerStateResponse = releaseLedgerStateResponse
        self.queryLedgerStateEraMismatch = queryLedgerStateEraMismatch
        self.queryLedgerStateUnavailableInCurrentEra = queryLedgerStateUnavailableInCurrentEra
        self.queryLedgerStateAcquiredExpired = queryLedgerStateAcquiredExpired
        self.queryLedgerStateConstitution = queryLedgerStateConstitution
        self.queryLedgerStateConstitutionResponse = queryLedgerStateConstitutionResponse
        self.queryLedgerStateConstitutionalCommittee = queryLedgerStateConstitutionalCommittee
        self.queryLedgerStateConstitutionalCommitteeResponse = queryLedgerStateConstitutionalCommitteeResponse
        self.queryLedgerStateDelegateRepresentatives = queryLedgerStateDelegateRepresentatives
        self.queryLedgerStateDelegateRepresentativesResponse = queryLedgerStateDelegateRepresentativesResponse
        self.queryLedgerStateDump = queryLedgerStateDump
        self.queryLedgerStateDumpResponse = queryLedgerStateDumpResponse
        self.queryLedgerStateEpoch = queryLedgerStateEpoch
        self.queryLedgerStateEpochResponse = queryLedgerStateEpochResponse
        self.queryLedgerStateEraStart = queryLedgerStateEraStart
        self.queryLedgerStateEraStartResponse = queryLedgerStateEraStartResponse
        self.queryLedgerStateEraSummaries = queryLedgerStateEraSummaries
        self.queryLedgerStateEraSummariesResponse = queryLedgerStateEraSummariesResponse
        self.queryLedgerStateGovernanceProposals = queryLedgerStateGovernanceProposals
        self.queryLedgerStateGovernanceProposalsResponse = queryLedgerStateGovernanceProposalsResponse
        self.queryLedgerStateLiveStakeDistribution = queryLedgerStateLiveStakeDistribution
        self.queryLedgerStateNonces = queryLedgerStateNonces
        self.queryLedgerStateNoncesResponse = queryLedgerStateNoncesResponse
        self.queryLedgerStateOperationalCertificates = queryLedgerStateOperationalCertificates
        self.queryLedgerStateOperationalCertificatesResponse = queryLedgerStateOperationalCertificatesResponse
        self.queryLedgerStateLiveStakeDistributionResponse = queryLedgerStateLiveStakeDistributionResponse
        self.queryLedgerStateProjectedRewards = queryLedgerStateProjectedRewards
        self.queryLedgerStateProjectedRewardsResponse = queryLedgerStateProjectedRewardsResponse
        self.queryLedgerStateProposedProtocolParameters = queryLedgerStateProposedProtocolParameters
        self.queryLedgerStateProposedProtocolParametersResponse = queryLedgerStateProposedProtocolParametersResponse
        self.queryLedgerStateProtocolParameters = queryLedgerStateProtocolParameters
        self.queryLedgerStateProtocolParametersResponse = queryLedgerStateProtocolParametersResponse
        self.queryLedgerStateRewardAccountSummaries = queryLedgerStateRewardAccountSummaries
        self.queryLedgerStateRewardAccountSummariesResponse = queryLedgerStateRewardAccountSummariesResponse
        self.queryLedgerStateRewardsProvenance = queryLedgerStateRewardsProvenance
        self.queryLedgerStateRewardsProvenanceResponse = queryLedgerStateRewardsProvenanceResponse
        self.queryLedgerStateStakePoolsPerformances = queryLedgerStateStakePoolsPerformances
        self.queryLedgerStateStakePoolsPerformancesResponse = queryLedgerStateStakePoolsPerformancesResponse
        self.queryLedgerStateStakePools = queryLedgerStateStakePools
        self.queryLedgerStateStakePoolsResponse = queryLedgerStateStakePoolsResponse
        self.queryLedgerStateTip = queryLedgerStateTip
        self.queryLedgerStateTipResponse = queryLedgerStateTipResponse
        self.queryLedgerStateTreasuryAndReserves = queryLedgerStateTreasuryAndReserves
        self.queryLedgerStateTreasuryAndReservesResponse = queryLedgerStateTreasuryAndReservesResponse
        self.queryLedgerStateUtxo = queryLedgerStateUtxo
        self.queryLedgerStateUtxoResponse = queryLedgerStateUtxoResponse
        self.queryNetworkBlockHeight = queryNetworkBlockHeight
        self.queryNetworkBlockHeightResponse = queryNetworkBlockHeightResponse
        self.queryNetworkGenesisConfiguration = queryNetworkGenesisConfiguration
        self.queryNetworkGenesisConfigurationResponse = queryNetworkGenesisConfigurationResponse
        self.queryNetworkInvalidGenesis = queryNetworkInvalidGenesis
        self.queryNetworkStartTime = queryNetworkStartTime
        self.queryNetworkStartTimeResponse = queryNetworkStartTimeResponse
        self.queryNetworkTip = queryNetworkTip
        self.queryNetworkTipResponse = queryNetworkTipResponse
        self.acquireMempool = acquireMempool
        self.acquireMempoolResponse = acquireMempoolResponse
        self.nextTransaction = nextTransaction
        self.mustAcquireMempoolFirst = mustAcquireMempoolFirst
        self.nextTransactionResponse = nextTransactionResponse
        self.hasTransaction = hasTransaction
        self.hasTransactionResponse = hasTransactionResponse
        self.sizeOfMempool = sizeOfMempool
        self.sizeOfMempoolResponse = sizeOfMempoolResponse
        self.releaseMempool = releaseMempool
        self.releaseMempoolResponse = releaseMempoolResponse
        self.rpcError = rpcError
    }
}
