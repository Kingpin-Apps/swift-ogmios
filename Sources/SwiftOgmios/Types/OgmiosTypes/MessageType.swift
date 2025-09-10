import Foundation

public enum MessageType: String, Codable, Sendable {
    case abstain = "abstain"
    case boolean = "boolean"
    case null = "null"
    case string = "string"
}
