import Foundation

// MARK: - Point
public struct Point: JSONSerializable {
    public let slot: Slot
    public let id: DigestBlake2b256
}

// MARK: - PointOrOrigin
public enum PointOrOrigin: JSONSerializable {
    case point(Point)
    case origin(Origin)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let point = try? container.decode(Point.self) {
            self = .point(point)
            return
        }
        if let origin = try? container.decode(Origin.self) {
            self = .origin(origin)
            return
        }
        throw DecodingError.typeMismatch(PointOrOrigin.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PointOrOrigin"))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .point(let point):
                try container.encode(point)
            case .origin(let origin):
                try container.encode(origin)
        }
    }
}


// MARK: - BlockHeightOrOrigin
public enum BlockHeightOrOrigin: JSONSerializable, Sendable {
    case blockHeight(BlockHeight)
    case origin(Origin)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let blockHeight = try? container.decode(BlockHeight.self) {
            self = .blockHeight(blockHeight)
            return
        }
        if let origin = try? container.decode(Origin.self) {
            self = .origin(origin)
            return
        }
        throw DecodingError.typeMismatch(
            BlockHeightOrOrigin.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Wrong type for BlockHeightOrOrigin"
            )
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .blockHeight(let blockHeight):
                try container.encode(blockHeight)
            case .origin(let origin):
                try container.encode(origin)
        }
    }
}

// MARK: - TipOrOrigin
public enum TipOrOrigin: JSONSerializable {
    case tip(Tip)
    case origin(Origin)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let tip = try? container.decode(Tip.self) {
            self = .tip(tip)
            return
        }
        if let origin = try? container.decode(Origin.self) {
            self = .origin(origin)
            return
        }
        throw DecodingError.typeMismatch(TipOrOrigin.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TipOrOrigin"))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .tip(let tip):
                try container.encode(tip)
            case .origin(let origin):
                try container.encode(origin)
        }
    }
}
