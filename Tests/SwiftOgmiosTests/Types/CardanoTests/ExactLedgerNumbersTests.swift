import Foundation
import Testing
@testable import SwiftOgmios

// Ledger numbers must decode exactly so they can be handed to SwiftCardanoCore
// (Coin = UInt64, token quantities, UnitInterval/NonNegativeInterval) without loss.

private func decode<T: Decodable>(_ type: T.Type, _ json: String) throws -> T {
    try JSONDecoder().decode(T.self, from: Data(json.utf8))
}

private let policyId = "b5ae663aaea8e500157bdf4baafd6f5ba0ce5759f7cd4101fc132f54"

// MARK: - Reference-script fee rationals (Decimal)

struct DecimalCase: Sendable, CustomTestStringConvertible {
    let text: String
    let significand: Decimal
    let exponent: Int

    var testDescription: String { text }
}

private let decimalCases: [DecimalCase] = [
    DecimalCase(text: "0.0577", significand: 577, exponent: -4),
    DecimalCase(text: "0.0000721", significand: 721, exponent: -7),
    DecimalCase(text: "1.2", significand: 12, exponent: -1),
    DecimalCase(text: "15", significand: 15, exponent: 0),
]

@Test(arguments: decimalCases)
func testMinFeeReferenceScriptsDecodesExactDecimal(_ testCase: DecimalCase) throws {
    let json = #"{"range":25600,"base":\#(testCase.text),"multiplier":\#(testCase.text)}"#
    let fees = try decode(MinFeeReferenceScripts.self, json)

    let expected = try #require(Decimal(string: testCase.text))
    #expect(fees.range == 25600)
    #expect(fees.base == expected)
    #expect(fees.multiplier == expected)
    #expect(fees.base.significand == testCase.significand)
    #expect(fees.base.exponent == testCase.exponent)
}

@Test func testMinFeeReferenceScriptsMultiplierIsNotBinaryRounded() throws {
    let fees = try decode(
        MinFeeReferenceScripts.self,
        #"{"range":25600,"base":15,"multiplier":1.2}"#
    )
    // 1.2 has no exact binary representation; the Decimal must be exactly 12/10.
    #expect(fees.multiplier * 10 == 12)
    #expect(fees.base == 15)
}

@Test func testProtocolParametersKeepReferenceScriptFeesExact() throws {
    let response = try JSONDecoder().decode(
        QueryLedgerStateProtocolParameters.Response.self,
        from: protocolParameters
    )
    let fees = try #require(response.result.minFeeReferenceScripts)
    #expect(fees.base == 15)
    #expect(fees.multiplier == Decimal(string: "1.2"))
    #expect(fees.range == 25600)
}

// MARK: - Output values (UInt64)

@Test func testOutputValueDecodesMaxTokenQuantityAndLovelace() throws {
    let json = """
    {"ada":{"lovelace":18446744073709551615},"\(policyId)":{"4d494e":18446744073709551615,"":1}}
    """
    let value = try decode(Value.self, json)

    #expect(value.ada.lovelace == UInt64.max)
    #expect(value.assets?[policyId]?["4d494e"] == 18446744073709551615)
    #expect(value.assets?[policyId]?[""] == 1)
}

@Test func testOutputValueRoundTripsMaxQuantity() throws {
    let value = Value(
        ada: Ada(lovelace: 2_000_000),
        assets: [policyId: ["4d494e": UInt64.max]]
    )
    let data = try JSONEncoder().encode(value)
    #expect(try JSONDecoder().decode(Value.self, from: data) == value)
}

struct RejectedValueCase: Sendable, CustomTestStringConvertible {
    let label: String
    let json: String

    var testDescription: String { label }
}

private let rejectedOutputValues: [RejectedValueCase] = [
    RejectedValueCase(
        label: "negative token quantity",
        json: #"{"ada":{"lovelace":1},"b5ae663aaea8e500157bdf4baafd6f5ba0ce5759f7cd4101fc132f54":{"4d494e":-1}}"#
    ),
    RejectedValueCase(
        label: "token quantity above UInt64.max",
        json: #"{"ada":{"lovelace":1},"b5ae663aaea8e500157bdf4baafd6f5ba0ce5759f7cd4101fc132f54":{"4d494e":18446744073709551616}}"#
    ),
    RejectedValueCase(
        label: "negative lovelace",
        json: #"{"ada":{"lovelace":-1}}"#
    ),
    RejectedValueCase(
        label: "fractional lovelace",
        json: #"{"ada":{"lovelace":1.5}}"#
    ),
]

@Test(arguments: rejectedOutputValues)
func testOutputValueRejectsOutOfRangeAmounts(_ testCase: RejectedValueCase) {
    #expect(throws: DecodingError.self) {
        _ = try decode(Value.self, testCase.json)
    }
}

@Test func testUtxoEntryDecodesMaxTokenQuantity() throws {
    let json = """
    {
      "transaction": {"id": "a2b5bb6b7a5d1b1b3f3ad4e2f7bb3a44a4f0aa6c3e4a0bbedf6b2f1e9e0c7d6f"},
      "index": 0,
      "address": "addr_test1vp8s8zu6mr73nvlsjf935k0a38n8xvp3fptkyz2vl8pserqkcx5yz",
      "value": {
        "ada": {"lovelace": 1344798},
        "\(policyId)": {"4d494e": 18446744073709551615}
      }
    }
    """
    let entry = try decode(UtxoEntry.self, json)
    #expect(entry.value.ada.lovelace == 1_344_798)
    #expect(entry.value.assets?[policyId]?["4d494e"] == UInt64.max)
}

@Test func testAdaOnlyValueDecodesFullCoinRange() throws {
    let value = try decode(ValueAdaOnly.self, #"{"ada":{"lovelace":18446744073709551615}}"#)
    #expect(value.ada.lovelace == UInt64.max)
}

// MARK: - Signed amounts (Int64)

@Test func testMintAssetsKeepNegativeQuantities() throws {
    let json = """
    {"\(policyId)":{"4d494e":-9223372036854775808,"4255524e":9223372036854775807}}
    """
    let mint = try decode(Assets.self, json)
    #expect(mint[policyId]?["4d494e"] == Int64.min)
    #expect(mint[policyId]?["4255524e"] == Int64.max)
}

@Test func testValueDeltaKeepsNegativeLovelace() throws {
    let delta = try decode(ValueDelta.self, #"{"ada":{"lovelace":-9223372036854775808}}"#)
    #expect(delta.ada.lovelace == Int64.min)
}

@Test func testRewardTransferKeepsNegativeDelta() throws {
    let json = """
    {"6d06fe0a5a8cb6d2bcc352581dea626bb5b2f66edf85678b2f2fa7b5":{"ada":{"lovelace":-123456789}}}
    """
    let transfer = try decode(RewardTransfer.self, json)
    #expect(transfer.value["6d06fe0a5a8cb6d2bcc352581dea626bb5b2f66edf85678b2f2fa7b5"]?.ada.lovelace == -123_456_789)
}

@Test func testSignedValueKeepsNegativeAmounts() throws {
    let json = """
    {"ada":{"lovelace":-5},"\(policyId)":{"4d494e":-42}}
    """
    let value = try decode(SignedValue.self, json)
    #expect(value.ada.lovelace == -5)
    #expect(value.assets?[policyId]?["4d494e"] == -42)

    let data = try JSONEncoder().encode(value)
    #expect(try JSONDecoder().decode(SignedValue.self, from: data) == value)
}

@Test func testInsufficientCollateralKeepsNegativeProvidedCollateral() throws {
    let json = """
    {"providedCollateral":{"ada":{"lovelace":-1000000}},"minimumRequiredCollateral":{"ada":{"lovelace":5000000}}}
    """
    let data = try decode(SubmitTransactionFailureInsufficientCollateral.InsufficientCollateralData.self, json)
    #expect(data.providedCollateral.ada.lovelace == -1_000_000)
    #expect(data.minimumRequiredCollateral.ada.lovelace == 5_000_000)
}

@Test func testTotalCollateralMismatchKeepsNegativeComputedCollateral() throws {
    let json = """
    {"declaredTotalCollateral":{"ada":{"lovelace":5000000}},"computedTotalCollateral":{"ada":{"lovelace":-250000}}}
    """
    let data = try decode(SubmitTransactionFailureTotalCollateralMismatch.TotalCollateralMismatchData.self, json)
    #expect(data.declaredTotalCollateral.ada.lovelace == 5_000_000)
    #expect(data.computedTotalCollateral.ada.lovelace == -250_000)
}

@Test func testMintValueMismatchKeepsBurnedQuantities() throws {
    let json = """
    {"mintedValue":{"ada":{"lovelace":0},"\(policyId)":{"4d494e":-10}},
     "expectedValue":{"ada":{"lovelace":0},"\(policyId)":{"4d494e":-9}}}
    """
    let data = try decode(SubmitTransactionFailureMintValueMismatch.MintValueMismatchData.self, json)
    #expect(data.mintedValue.assets?[policyId]?["4d494e"] == -10)
    #expect(data.expectedValue.assets?[policyId]?["4d494e"] == -9)
}

// MARK: - Other integer ledger values

@Test func testCostModelsDecodeFullInt64Range() throws {
    let json = #"{"plutus:v3":[100788,-9223372036854775808,9223372036854775807]}"#
    let models = try decode(CostModels.self, json)
    #expect(models.plutusV3 == [100788, Int64.min, Int64.max])
}

@Test func testOperationalCertificateCountersDecodeAsUInt64() throws {
    let json = #"{"pool1qqqqqdk4zhsjuxxd8jyvwncf5eucfskz0xjjj64fdmlgj735lr9":18446744073709551615}"#
    let certificates = try decode(OperationalCertificates.self, json)
    let counter = certificates.value.values.first
    #expect(counter == UInt64.max)
}
