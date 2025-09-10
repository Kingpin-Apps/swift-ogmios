// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let code = try? newJSONDecoder().decode(Code.self, from: jsonData)

import Foundation

// MARK: - Code
public struct Code: Codable, Sendable {
    public let type: CodeType
    public let codeEnum: [Int]

    public enum CodingKeys: String, CodingKey {
        case type
        case codeEnum = "enum"
    }

    public init(type: CodeType, codeEnum: [Int]) {
        self.type = type
        self.codeEnum = codeEnum
    }
}
