// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties16 = try? newJSONDecoder().decode(Properties16.self, from: jsonData)

import Foundation

// MARK: - Properties16
public struct Properties16: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: FriskyData?

    public init(code: Code, message: Message, data: FriskyData?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
