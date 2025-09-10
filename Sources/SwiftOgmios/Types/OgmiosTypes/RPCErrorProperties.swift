// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rPCErrorProperties = try? newJSONDecoder().decode(RPCErrorProperties.self, from: jsonData)

import Foundation

// MARK: - RPCErrorProperties
public struct RPCErrorProperties: Codable, Sendable {
    public let jsonrpc: Jsonrpc
    public let error: TentacledError
    public let id: ID

    public init(jsonrpc: Jsonrpc, error: TentacledError, id: ID) {
        self.jsonrpc = jsonrpc
        self.error = error
        self.id = id
    }
}
