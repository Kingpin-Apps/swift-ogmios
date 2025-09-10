// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties1 = try? newJSONDecoder().decode(Properties1.self, from: jsonData)

import Foundation

// MARK: - Properties1
public struct Properties1: Codable, Sendable {
    public let metadata: PropertyNames
    public let type: Jsonrpc
    public let invalidPreviousProposal: PropertyNames

    public init(metadata: PropertyNames, type: Jsonrpc, invalidPreviousProposal: PropertyNames) {
        self.metadata = metadata
        self.type = type
        self.invalidPreviousProposal = invalidPreviousProposal
    }
}
