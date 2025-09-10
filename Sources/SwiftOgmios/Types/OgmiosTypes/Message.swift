// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let message = try? newJSONDecoder().decode(Message.self, from: jsonData)

import Foundation

// MARK: - Message
public struct Message: Codable, Sendable {
    public let type: MessageType

    public init(type: MessageType) {
        self.type = type
    }
}
