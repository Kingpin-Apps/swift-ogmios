
/// Information related to the evolving nonce calculation in Praos, used to feed the randomness in the leader election schedule.
public struct Nonces: JSONSerializable, Equatable, Hashable, Sendable {
    public let epochNonce: Nonce
    public let candidateNonce: Nonce
    public let evolvingNonce: Nonce
    public let lastEpochLastAncestor: Nonce
    
    public enum Nonce: JSONSerializable, Equatable, Hashable, Sendable {
        case hash(DigestBlake2b256)
        case neutral
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let hash = try? container.decode(DigestBlake2b256.self) {
                self = .hash(hash)
            } else if let neutral = try? container.decode(String.self),
                        neutral == "neutral" {
                self = .neutral
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid Nonce value")
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .hash(let hash):
                try container.encode(hash)
            case .neutral:
                try container.encode("neutral")
            }
        }
        
        func callAsFunction() -> String {
            switch self {
                case .hash(let hash):
                    return hash()
                case .neutral:
                    return "neutral"
            }
        }
    }
}
