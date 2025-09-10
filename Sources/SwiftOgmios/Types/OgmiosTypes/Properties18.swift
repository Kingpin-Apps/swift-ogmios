// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties18 = try? newJSONDecoder().decode(Properties18.self, from: jsonData)

import Foundation

// MARK: - Properties18
public struct Properties18: Codable, Sendable {
    public let intersection, tip: PropertyNames

    public init(intersection: PropertyNames, tip: PropertyNames) {
        self.intersection = intersection
        self.tip = tip
    }
}
