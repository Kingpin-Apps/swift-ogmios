import Foundation

public enum AdditionalPropertiesUnion: Codable, Sendable {
    case bool(Bool)
    case propertyNames(PropertyNames)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(PropertyNames.self) {
            self = .propertyNames(x)
            return
        }
        throw DecodingError.typeMismatch(AdditionalPropertiesUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AdditionalPropertiesUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .propertyNames(let x):
            try container.encode(x)
        }
    }
}
