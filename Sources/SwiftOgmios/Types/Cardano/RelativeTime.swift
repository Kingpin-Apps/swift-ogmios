
/// A time in seconds relative to another one (typically, system start or era start).
public struct RelativeTime: JSONSerializable {
    public let seconds: UInt64
}

/// A slot length in milliseconds
public struct SlotLength: JSONSerializable {
    public let milliseconds: UInt64
}
