/// The origin of the blockchain. This point is special in the sense that it doesn't point to any existing slots, but is preceding any existing other point.
public enum Origin: Codable, Sendable, CustomStringConvertible {
    case origin
    
    public var description: String {
        return "origin"
    }
}
