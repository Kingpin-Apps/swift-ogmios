
/// A time in seconds relative to another one (typically, system start or era start).
public struct RelativeTime: Codable, Sendable {
    public let seconds: UInt64
}

/// A slot length in milliseconds
public struct SlotLength: Codable, Sendable {
    public let milliseconds: UInt64
}
