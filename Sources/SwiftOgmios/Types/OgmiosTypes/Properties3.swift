// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties3 = try? newJSONDecoder().decode(Properties3.self, from: jsonData)

import Foundation

// MARK: - Properties3
public struct Properties3: Codable, Sendable {
    public let budgetUsed: PropertyNames

    public init(budgetUsed: PropertyNames) {
        self.budgetUsed = budgetUsed
    }
}
