// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties9 = try? newJSONDecoder().decode(Properties9.self, from: jsonData)

import Foundation

// MARK: - Properties9
public struct Properties9: Codable, Sendable {
    public let proposals, outputReferences, addresses: ExtraneousRedeemers?

    public init(proposals: ExtraneousRedeemers?, outputReferences: ExtraneousRedeemers?, addresses: ExtraneousRedeemers?) {
        self.proposals = proposals
        self.outputReferences = outputReferences
        self.addresses = addresses
    }
}
