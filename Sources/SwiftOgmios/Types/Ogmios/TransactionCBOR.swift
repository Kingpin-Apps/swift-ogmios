public struct TransactionCBOR: JSONSerializable {
    /// CBOR-serialized signed transaction (base16)
    public let cbor: String
    
    /// Creates a new TransactionCBOR with the given CBOR hex string.
    /// - Parameter cbor: The CBOR-serialized signed transaction in base16 (hex) format.
    public init(cbor: String) {
        self.cbor = cbor
    }
}
