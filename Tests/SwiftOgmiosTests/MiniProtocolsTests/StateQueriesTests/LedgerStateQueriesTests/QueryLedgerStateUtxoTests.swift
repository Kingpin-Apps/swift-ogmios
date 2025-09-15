import Testing
@testable import SwiftOgmios

@Test func testQueryLedgerStateUtxoWholeSet() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    let wsClient = try await OgmiosClient(
        httpOnly: false,
        webSocketConnection: MockWebSocketConnection()
    )
    
    // Test querying whole UTXO set
    let utxoHTTP = try await httpClient
        .ledgerStateQuery
        .utxo
        .result(
            id: JSONRPCId.generateNextNanoId(),
            wholeUtxo: true
        )
    let utxoWS = try await wsClient
        .ledgerStateQuery
        .utxo
        .result(
            id: JSONRPCId.generateNextNanoId(),
            wholeUtxo: true
        )
    
    #expect(utxoHTTP.count == 3)
    #expect(utxoWS.count == 3)
    
    // Test first UTXO entry (simple ADA only)
    let firstUtxo = utxoHTTP[0]
    #expect(firstUtxo.transaction.id == "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef")
    #expect(firstUtxo.index == 0)
    #expect(firstUtxo.address.value == "addr_test1qz66ue36465w2qq40005h2hadad6pnjht8mu6sgplsfj74qdjnshguewlx4ww0eet26y2pal4xpav5prcydf28cvxtjqx46x7f")
    #expect(firstUtxo.value.ada.lovelace == 2000000)
    #expect(firstUtxo.value.assets == nil)
    #expect(firstUtxo.datumHash == nil)
    #expect(firstUtxo.datum == nil)
    #expect(firstUtxo.script == nil)
    
    // Test second UTXO entry (with native assets and datum hash)
    let secondUtxo = utxoHTTP[1]
    #expect(secondUtxo.transaction.id == "abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890")
    #expect(secondUtxo.index == 1)
    #expect(secondUtxo.value.ada.lovelace == 5000000)
    #expect(secondUtxo.value.assets != nil)
    #expect(secondUtxo.value.assets?["3542acb3a64d80c29302260d62c3b87a742ad14abf855ebc6733081e"]?["546f6b656e41"] == 100)
    #expect(secondUtxo.value.assets?["b5ae663aaea8e500157bdf4baafd6f5ba0ce5759f7cd4101fc132f54"]?["706174617465"] == 1337)
    #expect(secondUtxo.datumHash == "9e478573ab81ea7a8e31891ce0648b81229f408dcbf5b2b5516a89b9c0ce1f23")
    #expect(secondUtxo.script == nil)
    
    // Test third UTXO entry (with script)
    let thirdUtxo = utxoHTTP[2]
    #expect(thirdUtxo.transaction.id == "fedcba0987654321fedcba0987654321fedcba0987654321fedcba0987654321")
    #expect(thirdUtxo.index == 2)
    #expect(thirdUtxo.value.ada.lovelace == 10000000)
    #expect(thirdUtxo.script != nil)
    
    if case .plutus(let script) = thirdUtxo.script! {
        #expect(script.language == "plutus:v2")
        #expect(script.cbor.hasPrefix("59015859015501000032323232"))
    } else {
        #expect(Bool(false), "Expected Plutus script")
    }
}

@Test func testQueryLedgerStateUtxoWithParams() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    
    // Test with specific output references
    let outputRef = TransactionOutputReference(
        transaction: TransactionOutputReference.TransactionReference(
            id: "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
        ),
        index: 0
    )
    
    let utxoByRefs = try await httpClient
        .ledgerStateQuery
        .utxo
        .result(
            id: JSONRPCId.generateNextNanoId(),
            outputReferences: [outputRef]
        )
    
    #expect(utxoByRefs.count == 3) // Mock returns all 3, but in real usage would filter
    
    // Test with specific addresses
    let addresses = [
        Address("addr_test1qz66ue36465w2qq40005h2hadad6pnjht8mu6sgplsfj74qdjnshguewlx4ww0eet26y2pal4xpav5prcydf28cvxtjqx46x7f"),
        Address("addr_test1qqag3ume6wap6ywjhgs5g25fkrs4cq90dqtqsz8hs0l4x2k5vgk3l7gpqvxpg2qwqjv2f8g3jv8j8j9v2lq3l5x3j5x3z5j7w")
    ]
    
    let utxoByAddresses = try await httpClient
        .ledgerStateQuery
        .utxo
        .result(
            id: JSONRPCId.generateNextNanoId(),
            addresses: addresses
        )
    
    #expect(utxoByAddresses.count == 3) // Mock returns all 3, but in real usage would filter
}

@Test func testQueryLedgerStateUtxoParams() async throws {
    let httpClient = try await OgmiosClient(
        httpOnly: true,
        httpConnection: MockHTTPConnection()
    )
    
    // Test with enum params directly
    let utxoWithParams = try await httpClient
        .ledgerStateQuery
        .utxo
        .result(
            id: JSONRPCId.generateNextNanoId(),
            params: .wholeUtxo
        )
    
    #expect(utxoWithParams.count == 3)
    
    // Test with output references params
    let outputRef = TransactionOutputReference(
        transaction: TransactionOutputReference.TransactionReference(
            id: "test-tx-id"
        ),
        index: 1
    )
    
    let utxoWithRefParams = try await httpClient
        .ledgerStateQuery
        .utxo
        .result(
            id: JSONRPCId.generateNextNanoId(),
            params: .outputReferences([outputRef])
        )
    
    #expect(utxoWithRefParams.count == 3)
    
    // Test with address params
    let addresses = [Address("addr_test1qz66ue36465w2qq40005h2hadad6pnjht8mu6sgplsfj74qdjnshguewlx4ww0eet26y2pal4xpav5prcydf28cvxtjqx46x7f")]
    
    let utxoWithAddrParams = try await httpClient
        .ledgerStateQuery
        .utxo
        .result(
            id: JSONRPCId.generateNextNanoId(),
            params: .addresses(addresses)
        )
    
    #expect(utxoWithAddrParams.count == 3)
}
