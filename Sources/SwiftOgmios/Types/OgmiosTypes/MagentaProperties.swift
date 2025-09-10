// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let magentaProperties = try? newJSONDecoder().decode(MagentaProperties.self, from: jsonData)

import Foundation

// MARK: - MagentaProperties
public struct MagentaProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: StickyData?

    public init(code: Code, message: Message, data: StickyData?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
