
/// The input failed to deserialize in any of the known era.
public struct DeserialisationFailure: JSONRPCError {
    public let code: Int
    public let message: String
    public let data: DeserialisationFailureData
    
    public struct DeserialisationFailureData: JSONSerializable {
        public let shelley: String
        public let allegra: String
        public let mary: String
        public let alonzo: String
        public let babbage: String
        public let conway: String
    }
    
    init(
        code: Int = -32602,
        message: String = "Deserialisation failure",
        data: DeserialisationFailureData
    ) {
        self.code = code
        self.message = message
        self.data = data
    }
}

