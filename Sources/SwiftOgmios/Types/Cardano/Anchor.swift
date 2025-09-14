import Foundation

/// An era bound which captures the time, slot and epoch at which the era start. The time is relative to the start time of the network.
public struct Anchor: JSONSerializable {
    public let hash: DigestAny
    public let url: URL
}





