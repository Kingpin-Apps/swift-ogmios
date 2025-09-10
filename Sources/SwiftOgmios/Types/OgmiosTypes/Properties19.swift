// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties19 = try? newJSONDecoder().decode(Properties19.self, from: jsonData)

import Foundation

// MARK: - Properties19
public struct Properties19: Codable, Sendable {
    public let code: ApproximatePerformance
    public let message: AdditionalProperties
    public let data: ID

    public init(code: ApproximatePerformance, message: AdditionalProperties, data: ID) {
        self.code = code
        self.message = message
        self.data = data
    }
}
