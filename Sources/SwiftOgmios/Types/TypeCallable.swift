protocol StringCallable: JSONSerializable {
    associatedtype T: Codable & Sendable & Hashable & CustomStringConvertible
    
    var value: T { get }
    
    init(_ value: T) throws
}

extension StringCallable {
    func callAsFunction() -> T {
        return value
    }
    
    public var description: String {
        return "\(value)"
    }
    
    // For JSON decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(T.self)
        try self.init(value)
    }
    
    // For JSON encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
