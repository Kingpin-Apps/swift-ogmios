// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties17 = try? newJSONDecoder().decode(Properties17.self, from: jsonData)

import Foundation

// MARK: - Properties17
public struct Properties17: Codable, Sendable {
    public let tip: PropertyNames

    public init(tip: PropertyNames) {
        self.tip = tip
    }
}
