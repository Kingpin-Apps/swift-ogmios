import Foundation

public protocol Connectable {
    func sendRequest(json: String) async throws -> Data
}
