// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectedRewardsPropertyNames = try? newJSONDecoder().decode(ProjectedRewardsPropertyNames.self, from: jsonData)

import Foundation

// MARK: - ProjectedRewardsPropertyNames
public struct ProjectedRewardsPropertyNames: Codable, Sendable {
    public let pattern: String

    public init(pattern: String) {
        self.pattern = pattern
    }
}
