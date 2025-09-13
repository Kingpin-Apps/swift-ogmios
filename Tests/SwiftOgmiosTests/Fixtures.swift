import Foundation
import System
@testable import SwiftOgmios

public func mockSendRequest(json: String) async throws -> Data {
    let requestJSON = try JSONSerialization
        .jsonObject(
            with: json.data(using: .utf8)!,
            options: []
        ) as? [String: Any]
    
    let method = requestJSON?["method"] as? String ?? ""
    
    switch method {
        case "queryLedgerState/epoch":
            return mockEpoch
        case "queryLedgerState/constitution":
            return mockConstitution
        case "queryLedgerState/constitutionalCommittee":
            return mockConstitutionalCommittee
        case "queryLedgerState/delegateRepresentatives":
            return mockDelegateRepresentatives
        case "queryLedgerState/dump":
            let message = "some test data"
            let params = requestJSON?["params"] as? [String: Any]
            let tempFilePath = params!["to"] as? String ?? ""
            let path = URL(fileURLWithPath: tempFilePath)
            try message.write(to: path, atomically: true, encoding: .utf8)
            return mockDump
        case "queryLedgerState/eraStart":
            return mockEraStart
        case "queryLedgerState/eraSummaries":
            return mockEraSummaries
        case "queryLedgerState/governanceProposals":
            return mockGovernanceProposals
        case "queryLedgerState/liveStakeDistribution":
            return mockLiveStakeDistribution
        case "queryLedgerState/nonces":
            return nonces
        case "queryLedgerState/operationalCertificates":
            return operationalCertificates
        case "queryLedgerState/projectedRewards":
            return projectedRewards
        case "queryLedgerState/protocolParameters":
            return protocolParameters
        case "queryLedgerState/proposedProtocolParameters":
            return proposedProtocolParameters
        case "queryLedgerState/rewardAccountSummaries":
            return rewardAccountSummaries
        case "queryLedgerState/rewardsProvenance":
            return rewardsProvenance
        case "queryLedgerState/stakePoolsPerformances":
            return stakePoolsPerformances
        case "queryLedgerState/stakePools":
            return stakePools
        case "queryLedgerState/utxo":
            return utxo
        case "queryLedgerState/tip":
            return tip
        case "queryLedgerState/treasuryAndReserves":
            return treasuryAndReserves
        default:
            return Data()
    }
}

public final class MockWebSocketConnection: WebSocketConnectable {
    public func close() {
        // No-op for mock
    }

    public func sendRequest(json: String) async throws -> Data {
        return try await mockSendRequest(json: json)
    }
    
}

public final class MockHTTPConnection: HTTPConnectable {
    public func sendRequest(json: String) async throws -> Data {
        return try await mockSendRequest(json: json)
    }

    public func get(url: URL) async throws -> Data {
        let response = """
        {
          "currentEra" : "conway",
          "lastKnownTip" : {
            "slot" : 90908555,
            "id" : "9ec5a59cde0ecf03d08b092be24a3347eae125276f2c39af282a32135b35b897",
            "height" : 3595887
          },
          "connectionStatus" : "connected",
          "slotInEpoch" : 15755,
          "startTime" : "2025-09-10T12:57:15.352626Z",
          "lastTipUpdate" : "2025-09-11T04:22:35.257027Z",
          "currentEpoch" : 1052,
          "version" : "v6.13.0 (4e93e254)",
          "metrics" : {
            "totalConnections" : 168,
            "totalUnrouted" : 0,
            "runtimeStats" : {
              "cpuTime" : 91829243000,
              "maxHeapSize" : 26005,
              "currentHeapSize" : 1797,
              "gcCpuTime" : 83862521000
            },
            "totalMessages" : 315,
            "activeConnections" : 1,
            "sessionDurations" : {
              "max" : 0,
              "min" : 0,
              "mean" : 1178.688622754491
            }
          },
          "network" : "preview",
          "networkSynchronization" : 1
        }
        """
        return Data(response.utf8)
    }
}
