// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let oneOfExample = try? newJSONDecoder().decode(OneOfExample.self, from: jsonData)

import Foundation

// MARK: - OneOfExample
public struct OneOfExample: Codable, Sendable {
    public let jsonrpc: String
    public let result: [ResultElement]

    public init(jsonrpc: String, result: [ResultElement]) {
        self.jsonrpc = jsonrpc
        self.result = result
    }
}
