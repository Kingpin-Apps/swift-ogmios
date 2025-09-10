// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let response = try? newJSONDecoder().decode(Response.self, from: jsonData)

import Foundation

// MARK: - Response
public struct Response: Codable, Sendable {
    public let oneOf: [QueryNetworkStartTimeResponse]

    public init(oneOf: [QueryNetworkStartTimeResponse]) {
        self.oneOf = oneOf
    }
}
