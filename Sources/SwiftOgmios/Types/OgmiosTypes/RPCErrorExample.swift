// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rPCErrorExample = try? newJSONDecoder().decode(RPCErrorExample.self, from: jsonData)

import Foundation

// MARK: - RPCErrorExample
public struct RPCErrorExample: Codable, Sendable {
    public let jsonrpc: String
    public let error: ExampleError

    public init(jsonrpc: String, error: ExampleError) {
        self.jsonrpc = jsonrpc
        self.error = error
    }
}
