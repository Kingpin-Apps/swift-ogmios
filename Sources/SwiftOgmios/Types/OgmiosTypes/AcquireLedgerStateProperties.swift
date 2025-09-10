// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let acquireLedgerStateProperties = try? newJSONDecoder().decode(AcquireLedgerStateProperties.self, from: jsonData)

import Foundation

// MARK: - AcquireLedgerStateProperties
public struct AcquireLedgerStateProperties: Codable, Sendable {
    public let jsonrpc, method: Jsonrpc
    public let params: Params?
    public let id: ID
    public let error: PurpleError?
    public let result: PurpleResult?

    public init(jsonrpc: Jsonrpc, method: Jsonrpc, params: Params?, id: ID, error: PurpleError?, result: PurpleResult?) {
        self.jsonrpc = jsonrpc
        self.method = method
        self.params = params
        self.id = id
        self.error = error
        self.result = result
    }
}
