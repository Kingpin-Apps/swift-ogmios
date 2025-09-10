import Foundation

public enum AcquireLedgerStateRequired: String, Codable, Sendable {
    case error = "error"
    case jsonrpc = "jsonrpc"
    case method = "method"
    case params = "params"
    case result = "result"
}
