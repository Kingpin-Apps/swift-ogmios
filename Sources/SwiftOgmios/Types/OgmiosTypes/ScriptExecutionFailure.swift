// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let scriptExecutionFailure = try? newJSONDecoder().decode(ScriptExecutionFailure.self, from: jsonData)

import Foundation

// MARK: - ScriptExecutionFailure
public struct ScriptExecutionFailure: Codable, Sendable {
    public let oneOf: [ScriptExecutionFailureOneOf]

    public init(oneOf: [ScriptExecutionFailureOneOf]) {
        self.oneOf = oneOf
    }
}
