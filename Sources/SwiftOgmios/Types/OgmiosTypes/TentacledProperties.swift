// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tentacledProperties = try? newJSONDecoder().decode(TentacledProperties.self, from: jsonData)

import Foundation

// MARK: - TentacledProperties
public struct TentacledProperties: Codable, Sendable {
    public let validator, error: PropertyNames

    public init(validator: PropertyNames, error: PropertyNames) {
        self.validator = validator
        self.error = error
    }
}
