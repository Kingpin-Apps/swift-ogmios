// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let insufficientlyFundedOutputs = try? newJSONDecoder().decode(InsufficientlyFundedOutputs.self, from: jsonData)

import Foundation

// MARK: - InsufficientlyFundedOutputs
public struct InsufficientlyFundedOutputs: Codable, Sendable {
    public let type: ExtraneousRedeemersType
    public let items: InsufficientlyFundedOutputsItems

    public init(type: ExtraneousRedeemersType, items: InsufficientlyFundedOutputsItems) {
        self.type = type
        self.items = items
    }
}
