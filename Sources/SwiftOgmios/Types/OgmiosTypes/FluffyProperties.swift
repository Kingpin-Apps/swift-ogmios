// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fluffyProperties = try? newJSONDecoder().decode(FluffyProperties.self, from: jsonData)

import Foundation

// MARK: - FluffyProperties
public struct FluffyProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: FluffyData

    public init(code: Code, message: Message, data: FluffyData) {
        self.code = code
        self.message = message
        self.data = data
    }
}
