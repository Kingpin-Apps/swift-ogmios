
/// An era bound which captures the time, slot and epoch at which the era start. The time is relative to the start time of the network.
public struct Bound: JSONSerializable {
    public let time: RelativeTime
    public let slot: Slot
    public let epoch: Epoch
}


