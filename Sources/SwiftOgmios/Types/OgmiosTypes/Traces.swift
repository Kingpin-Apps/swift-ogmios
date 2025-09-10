// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let traces = try? newJSONDecoder().decode(Traces.self, from: jsonData)

import Foundation

// MARK: - Traces
public struct Traces: Codable, Sendable {
    public let type: ExtraneousRedeemersType
    public let items: Message

    public init(type: ExtraneousRedeemersType, items: Message) {
        self.type = type
        self.items = items
    }
}
