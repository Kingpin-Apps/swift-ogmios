// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties14 = try? newJSONDecoder().decode(Properties14.self, from: jsonData)

import Foundation

// MARK: - Properties14
public struct Properties14: Codable, Sendable {
    public let validator, budget: PropertyNames

    public init(validator: PropertyNames, budget: PropertyNames) {
        self.validator = validator
        self.budget = budget
    }
}
