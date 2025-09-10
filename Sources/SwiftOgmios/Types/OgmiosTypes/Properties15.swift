// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties15 = try? newJSONDecoder().decode(Properties15.self, from: jsonData)

import Foundation

// MARK: - Properties15
public struct Properties15: Codable, Sendable {
    public let jsonrpc, method: Jsonrpc
    public let result: TentacledResult?
    public let id: ID
    public let error: FluffyError?

    public init(jsonrpc: Jsonrpc, method: Jsonrpc, result: TentacledResult?, id: ID, error: FluffyError?) {
        self.jsonrpc = jsonrpc
        self.method = method
        self.result = result
        self.id = id
        self.error = error
    }
}
