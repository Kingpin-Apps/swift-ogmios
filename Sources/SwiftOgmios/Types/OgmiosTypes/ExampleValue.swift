// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let exampleValue = try? newJSONDecoder().decode(ExampleValue.self, from: jsonData)

import Foundation

// MARK: - ExampleValue
public struct ExampleValue: Codable, Sendable {
    public let stake, vrf: String

    public init(stake: String, vrf: String) {
        self.stake = stake
        self.vrf = vrf
    }
}
