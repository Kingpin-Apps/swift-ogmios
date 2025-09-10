// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let exampleError = try? newJSONDecoder().decode(ExampleError.self, from: jsonData)

import Foundation

// MARK: - ExampleError
public struct ExampleError: Codable, Sendable {
    public let message, code: String

    public init(message: String, code: String) {
        self.message = message
        self.code = code
    }
}
