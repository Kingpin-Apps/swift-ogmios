// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties7 = try? newJSONDecoder().decode(Properties7.self, from: jsonData)

import Foundation

// MARK: - Properties7
public struct Properties7: Codable, Sendable {
    public let unknownOutputReferences: ExtraneousRedeemers

    public init(unknownOutputReferences: ExtraneousRedeemers) {
        self.unknownOutputReferences = unknownOutputReferences
    }
}
