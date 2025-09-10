// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties8 = try? newJSONDecoder().decode(Properties8.self, from: jsonData)

import Foundation

// MARK: - Properties8
public struct Properties8: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: MagentaData?

    public init(code: Code, message: Message, data: MagentaData?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
