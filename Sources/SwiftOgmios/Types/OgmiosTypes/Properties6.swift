// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties6 = try? newJSONDecoder().decode(Properties6.self, from: jsonData)

import Foundation

// MARK: - Properties6
public struct Properties6: Codable, Sendable {
    public let missingDatums: ExtraneousRedeemers

    public init(missingDatums: ExtraneousRedeemers) {
        self.missingDatums = missingDatums
    }
}
