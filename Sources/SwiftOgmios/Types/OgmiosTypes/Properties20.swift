// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties20 = try? newJSONDecoder().decode(Properties20.self, from: jsonData)

import Foundation

// MARK: - Properties20
public struct Properties20: Codable, Sendable {
    public let jsonrpc, method: Jsonrpc
    public let result: StickyResult?
    public let id: ID
    public let error: PropertyNames?

    public init(jsonrpc: Jsonrpc, method: Jsonrpc, result: StickyResult?, id: ID, error: PropertyNames?) {
        self.jsonrpc = jsonrpc
        self.method = method
        self.result = result
        self.id = id
        self.error = error
    }
}
