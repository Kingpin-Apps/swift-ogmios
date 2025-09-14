public struct EraMismatch: JSONSerializable, Sendable {
    public let queryEra: Era
    public let ledgerEra: Era
}
