import Foundation

public enum AnyStakeCredential: JSONSerializable, Sendable {
    case base16(EncodingBase16)
    case bech32(Bech32StakeVkhScript)
    case stakeAddress(StakeAddress)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let base16 = try? container.decode(EncodingBase16.self) {
            self = .base16(base16)
        } else if let bech32 = try? container.decode(Bech32StakeVkhScript.self) {
            self = .bech32(bech32)
        } else if let stakeAddress = try? container.decode(StakeAddress.self) {
            self = .stakeAddress(stakeAddress)
        } else {
            throw DecodingError.typeMismatch(AnyDelegateRepresentativeCredential.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid AnyDelegateRepresentativeCredential"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .base16(let base16):
                try container.encode(base16)
            case .bech32(let bech32):
                try container.encode(bech32)
            case .stakeAddress(let stakeAddress):
                try container.encode(stakeAddress)
        }
    }
}


public enum AnyDelegateRepresentativeCredential: JSONSerializable, Sendable {
    case base16(EncodingBase16)
    case bech32(Bech32DRepVkhDRepScript)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let base16 = try? container.decode(EncodingBase16.self) {
            self = .base16(base16)
        } else if let bech32 = try? container.decode(Bech32DRepVkhDRepScript.self) {
            self = .bech32(bech32)
        } else {
            throw DecodingError.typeMismatch(AnyDelegateRepresentativeCredential.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid AnyDelegateRepresentativeCredential"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .base16(let base16):
                try container.encode(base16)
            case .bech32(let bech32):
                try container.encode(bech32)
        }
    }
}

