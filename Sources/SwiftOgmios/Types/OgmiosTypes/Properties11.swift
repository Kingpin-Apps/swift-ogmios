// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties11 = try? newJSONDecoder().decode(Properties11.self, from: jsonData)

import Foundation

// MARK: - Properties11
public struct Properties11: Codable, Sendable {
    public let direction: Jsonrpc?
    public let tip, block, point: PropertyNames?
    public let members: ExtraneousRedeemers?
    public let quorum: Quorum?

    public init(direction: Jsonrpc?, tip: PropertyNames?, block: PropertyNames?, point: PropertyNames?, members: ExtraneousRedeemers?, quorum: Quorum?) {
        self.direction = direction
        self.tip = tip
        self.block = block
        self.point = point
        self.members = members
        self.quorum = quorum
    }
}
