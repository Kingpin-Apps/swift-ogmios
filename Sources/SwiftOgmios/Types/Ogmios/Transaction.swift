public struct Transaction: JSONSerializable {
    /// CBOR-serialized signed transaction (base16)
    public let cbor: String
}
