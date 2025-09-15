/// The origin of the blockchain. This point is special in the sense that it doesn't point to any existing slots, but is preceding any existing other point.
public enum Origin: JSONSerializable {
    case origin
    
    public var description: String {
        return "origin"
    }
}

// MARK: - Tip
public struct Tip: JSONSerializable {
    public let slot: Slot
    public let id: DigestBlake2b256
    public let height: BlockHeight
}
