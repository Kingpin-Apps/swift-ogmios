// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let resultElement = try? newJSONDecoder().decode(ResultElement.self, from: jsonData)

import Foundation

// MARK: - ResultElement
public struct ResultElement: Codable, Sendable {
    public let validator: String
    public let budget: Budget

    public init(validator: String, budget: Budget) {
        self.validator = validator
        self.budget = budget
    }
}
