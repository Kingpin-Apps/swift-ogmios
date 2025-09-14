import Testing
@testable import SwiftOgmios

@Test(arguments: EraWithGenesis.allCases)
func testQueryNetworkGenesisConfiguration(_ era: EraWithGenesis) async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    let genesisConfigurationHTTP = try await httpClient
        .networkQuery
        .genesisConfiguration
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(era: era)
        )
    let genesisConfigurationWS = try await wsClient
        .networkQuery
        .genesisConfiguration
        .execute(
            id: JSONRPCId.generateNextNanoId(),
            params: .init(era: era)
        )
    
    // Test each genesis configuration era
    if case let .byron(byronConfig) = genesisConfigurationHTTP.result {
        #expect(byronConfig.era == "byron")
    } else if case let .conway(conwayConfig) = genesisConfigurationHTTP.result {
        #expect(conwayConfig.era == "conway")
    } else if case let .alonzo(alonzoConfig) = genesisConfigurationHTTP.result {
        #expect(alonzoConfig.era == "alonzo")
    } else if case let .shelley(shelleyConfig) = genesisConfigurationHTTP.result {
        #expect(shelleyConfig.era == "shelley")
    }
    
    if case let .byron(byronConfig) = genesisConfigurationWS.result {
        #expect(byronConfig.era == "byron")
    } else if case let .conway(conwayConfig) = genesisConfigurationWS.result {
        #expect(conwayConfig.era == "conway")
    } else if case let .alonzo(alonzoConfig) = genesisConfigurationWS.result {
        #expect(alonzoConfig.era == "alonzo")
    } else if case let .shelley(shelleyConfig) = genesisConfigurationWS.result {
        #expect(shelleyConfig.era == "shelley")
    }
            
}


