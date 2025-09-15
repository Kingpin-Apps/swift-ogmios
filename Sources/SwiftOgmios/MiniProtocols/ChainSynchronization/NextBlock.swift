import Foundation
import Logging


/// Request next block from the current cardano-node's cursor.
public struct NextBlock {
    private let client: OgmiosClient
    
    private static let method: String = "nextBlock"
    private static let jsonrpc: String = JSONRPCVersion
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Never?
        public let id: JSONRPCId?
        
        public init(id: JSONRPCId? = nil) {
            self.id = id
            self.method = NextBlock.method
            self.jsonrpc = NextBlock.jsonrpc
            self.params = nil
        }
    }
    
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: Result
        public let id: JSONRPCId?
        
        public init(result: Result, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = NextBlock.method
            self.jsonrpc = NextBlock.jsonrpc
        }
    }
    
    // MARK: - Result
    public enum Result: JSONSerializable {
        case rollforward(RollForward)
        case rollBackward(RollBackward)
        
        enum CodingKeys: String, CodingKey {
            case direction = "direction"
        }
        
        public struct RollForward: JSONSerializable {
            public let direction: String
            public let tip: Tip
            public let block: Block
            
            init(direction: String = "forward", tip: Tip, block: Block) {
                self.direction = direction
                self.tip = tip
                self.block = block
            }
        }
        
        public struct RollBackward: JSONSerializable {
            public let direction: String
            public let tip: TipOrOrigin
            public let point: PointOrOrigin
            
            init(direction: String = "backward", tip: TipOrOrigin, point: PointOrOrigin) {
                self.direction = direction
                self.tip = tip
                self.point = point
            }
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let direction = try container.decode(String.self, forKey: .direction)
            switch direction {
                case "forward":
                    let rollForward = try RollForward(from: decoder)
                    self = .rollforward(rollForward)
                case "backward":
                    let rollBackward = try RollBackward(from: decoder)
                    self = .rollBackward(rollBackward)
                default:
                    throw DecodingError.dataCorruptedError(forKey: .direction, in: container, debugDescription: "Invalid direction value: \(direction)")
            }
        }
        
        public func encode(to encoder: any Encoder) throws {
            switch self {
                case .rollforward(let rollForward):
                    try rollForward.encode(to: encoder)
                case .rollBackward(let rollBackward):
                    try rollBackward.encode(to: encoder)
            }
        }
    }
    
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil) async throws -> Result {
        let response = try await self.execute(id: id)
        return response.result
    }
    
    public func execute(id: JSONRPCId? = nil) async throws -> Response {
        let data = try await self.send(id: id)
        return try await self.process(data: data)
    }
    
    // MARK: - Private Methods
    private func send(id: JSONRPCId? = nil) async throws -> Data {
        let request = Request(id: id)
        return try await client.sendRequestJSON(request)
    }
    
    private func process(data: Data) async throws -> Response {
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let responseJSON = responseJSON else {
            throw OgmiosError.invalidResponse("Response is not a valid JSON object")
        }
        
        guard let method = responseJSON["method"] as? String,
              method == NextBlock.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(NextBlock.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let code = error["code"] as? Int {
            
            let response: any JSONRPCResponseError
            if code == 4000 {
                response = try MustAcquireMempoolFirst.fromJSONData(data)
            } else {
                throw OgmiosError
                    .responseError("Ogmios returned an unknown error code: \(code)")
            }
            
            client.logResponseError(response: response)
            throw OgmiosError
                .responseError(
                    "Ogmios returned an error: \(String(describing: response.error.message))"
                )
        }
        
        let response = try Response.fromJSONData(data)
        client.logResponse(response: response)
        
        return response
    }
}
