// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let computedProperties = try? newJSONDecoder().decode(ComputedProperties.self, from: jsonData)

import Foundation

// MARK: - ComputedProperties
public struct ComputedProperties: Codable, Sendable {
    public let hash: PropertyNames

    public init(hash: PropertyNames) {
        self.hash = hash
    }
}
