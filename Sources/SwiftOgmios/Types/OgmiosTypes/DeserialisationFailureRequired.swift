import Foundation

public enum DeserialisationFailureRequired: String, Codable, Sendable {
    case code = "code"
    case data = "data"
    case message = "message"
}
