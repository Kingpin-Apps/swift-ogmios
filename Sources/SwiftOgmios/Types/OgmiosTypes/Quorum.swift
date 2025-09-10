// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quorum = try? newJSONDecoder().decode(Quorum.self, from: jsonData)

import Foundation

// MARK: - Quorum
public struct Quorum: Codable, Sendable {
    public let oneOf: [QuorumOneOf]

    public init(oneOf: [QuorumOneOf]) {
        self.oneOf = oneOf
    }
}
