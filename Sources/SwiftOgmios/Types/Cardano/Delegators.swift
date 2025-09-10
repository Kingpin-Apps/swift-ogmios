import Foundation

// MARK: - Delegator
public struct Delegator: Codable, Sendable {
    public let credential: DigestBlake2b224
    public let from: CredentialOrigin
}
