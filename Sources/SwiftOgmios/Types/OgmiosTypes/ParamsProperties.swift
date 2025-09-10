// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let paramsProperties = try? newJSONDecoder().decode(ParamsProperties.self, from: jsonData)

import Foundation

// MARK: - ParamsProperties
public struct ParamsProperties: Codable, Sendable {
    public let point: PropertyNames?
    public let transaction: PurpleTransaction?
    public let additionalUtxo: PropertyNames?
    public let points: ExtraneousRedeemers?
    public let id: PropertyNames?
    public let fields: Jsonrpc?
    public let scripts, keys: ExtraneousRedeemers?
    public let to: AdditionalProperties?
    public let stake: ExtraneousRedeemers?
    public let includeStake: AdditionalProperties?
    public let stakePools: TentacledStakePools?
    public let era: PropertyNames?

    public init(point: PropertyNames?, transaction: PurpleTransaction?, additionalUtxo: PropertyNames?, points: ExtraneousRedeemers?, id: PropertyNames?, fields: Jsonrpc?, scripts: ExtraneousRedeemers?, keys: ExtraneousRedeemers?, to: AdditionalProperties?, stake: ExtraneousRedeemers?, includeStake: AdditionalProperties?, stakePools: TentacledStakePools?, era: PropertyNames?) {
        self.point = point
        self.transaction = transaction
        self.additionalUtxo = additionalUtxo
        self.points = points
        self.id = id
        self.fields = fields
        self.scripts = scripts
        self.keys = keys
        self.to = to
        self.stake = stake
        self.includeStake = includeStake
        self.stakePools = stakePools
        self.era = era
    }
}
