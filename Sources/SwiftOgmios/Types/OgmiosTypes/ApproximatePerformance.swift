// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let approximatePerformance = try? newJSONDecoder().decode(ApproximatePerformance.self, from: jsonData)

import Foundation

// MARK: - ApproximatePerformance
public struct ApproximatePerformance: Codable, Sendable {
    public let type, description: String
    public let minimum: Int
    public let maximum: Double?

    public init(type: String, description: String, minimum: Int, maximum: Double?) {
        self.type = type
        self.description = description
        self.minimum = minimum
        self.maximum = maximum
    }
}
