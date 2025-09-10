// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let friskyProperties = try? newJSONDecoder().decode(FriskyProperties.self, from: jsonData)

import Foundation

// MARK: - FriskyProperties
public struct FriskyProperties: Codable, Sendable {
    public let expectedNetwork: PropertyNames
    public let discriminatedType: Jsonrpc
    public let invalidEntities: ExtraneousRedeemers?

    public init(expectedNetwork: PropertyNames, discriminatedType: Jsonrpc, invalidEntities: ExtraneousRedeemers?) {
        self.expectedNetwork = expectedNetwork
        self.discriminatedType = discriminatedType
        self.invalidEntities = invalidEntities
    }
}
