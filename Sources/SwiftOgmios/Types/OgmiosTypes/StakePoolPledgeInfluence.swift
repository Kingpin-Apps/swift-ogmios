// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stakePoolPledgeInfluence = try? newJSONDecoder().decode(StakePoolPledgeInfluence.self, from: jsonData)

import Foundation

// MARK: - StakePoolPledgeInfluence
public struct StakePoolPledgeInfluence: Codable, Sendable {
    public let type: MessageType
    public let description, pattern: String
    public let examples: [String]?
    public let contentEncoding: String?

    public init(type: MessageType, description: String, pattern: String, examples: [String]?, contentEncoding: String?) {
        self.type = type
        self.description = description
        self.pattern = pattern
        self.examples = examples
        self.contentEncoding = contentEncoding
    }
}
