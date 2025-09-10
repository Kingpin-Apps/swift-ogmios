import Foundation

public enum PurpleRequired: String, Codable, Sendable {
    case discriminatedType = "discriminatedType"
    case expectedNetwork = "expectedNetwork"
    case invalidEntities = "invalidEntities"
}
