// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let findIntersectionResponse = try? newJSONDecoder().decode(FindIntersectionResponse.self, from: jsonData)

import Foundation

// MARK: - FindIntersectionResponse
public struct FindIntersectionResponse: Codable, Sendable {
    public let oneOf: [FindIntersectionResponseOneOf]

    public init(oneOf: [FindIntersectionResponseOneOf]) {
        self.oneOf = oneOf
    }
}
