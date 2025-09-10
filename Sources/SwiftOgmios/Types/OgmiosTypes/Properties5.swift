// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties5 = try? newJSONDecoder().decode(Properties5.self, from: jsonData)

import Foundation

// MARK: - Properties5
public struct Properties5: Codable, Sendable {
    public let missingCostModels: ExtraneousRedeemers

    public init(missingCostModels: ExtraneousRedeemers) {
        self.missingCostModels = missingCostModels
    }
}
