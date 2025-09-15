import Foundation
import Logging


/// Query the list of all stake pools currently registered and active, optionally filtered by ids.
public struct QueryLedgerStateStakePools {
    private let client: OgmiosClient
    
    private static let method: String = "queryLedgerState/stakePools"
    private static let jsonrpc: String = JSONRPCVersion
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Params
    public struct Params: JSONSerializable, Sendable {
        /// When provided and set to 'true', the result will also include the voting stake associated to each pool.
        public let includeStake: Bool?
        
        /// Optional array of stake pool IDs to filter the results
        public let stakePools: [StakePoolId]?
        
        public init(includeStake: Bool? = nil, stakePools: [StakePoolId]? = nil) {
            self.includeStake = includeStake
            self.stakePools = stakePools
        }
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Params?
        public let id: JSONRPCId?
        
        init(params: Params? = nil, id: JSONRPCId? = nil) {
            self.id = id
            self.method = QueryLedgerStateStakePools.method
            self.jsonrpc = QueryLedgerStateStakePools.jsonrpc
            self.params = params
        }
    }
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: [StakePoolId: StakePool]
        public let id: JSONRPCId?
        
        init(result: [StakePoolId: StakePool], id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = QueryLedgerStateStakePools.method
            self.jsonrpc = QueryLedgerStateStakePools.jsonrpc
        }
        
        // Custom decoding to handle the dictionary keys properly
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            jsonrpc = try container.decode(String.self, forKey: .jsonrpc)
            method = try container.decode(String.self, forKey: .method)
            id = try container.decodeIfPresent(JSONRPCId.self, forKey: .id)
            
            // Decode result from string keys to StakePoolId keys
            let resultContainer = try container.decode([String: StakePool].self, forKey: .result)
            result = try Dictionary(uniqueKeysWithValues: 
                resultContainer.map { key, value in 
                    (try StakePoolId(key), value)
                }
            )
        }
        
        // Custom encoding to handle the dictionary keys properly
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(jsonrpc, forKey: .jsonrpc)
            try container.encode(method, forKey: .method)
            try container.encodeIfPresent(id, forKey: .id)
            
            // Encode result with string keys
            let stringKeyedResult = Dictionary(uniqueKeysWithValues: 
                result.map { key, value in 
                    (key.value, value)
                }
            )
            try container.encode(stringKeyedResult, forKey: .result)
        }
        
        private enum CodingKeys: String, CodingKey {
            case jsonrpc
            case method
            case result
            case id
        }
    }
    
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil, params: Params? = nil) async throws -> [StakePoolId: StakePool] {
        let response = try await self.execute(id: id, params: params)
        return response.result
    }
    
    public func execute(id: JSONRPCId? = nil, params: Params? = nil) async throws -> Response {
        let data = try await self.send(params: params, id: id)
        return try await self.process(data: data)
    }
    
    // MARK: - Private Methods
    private func send(params: Params? = nil, id: JSONRPCId? = nil) async throws -> Data {
        let request = Request(params: params, id: id)
        return try await client.sendRequestJSON(request)
    }
    
    private func process(data: Data) async throws -> Response {
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let responseJSON = responseJSON else {
            throw OgmiosError.invalidResponse("Response is not a valid JSON object")
        }
        
        guard let method = responseJSON["method"] as? String,
              method == QueryLedgerStateStakePools.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(QueryLedgerStateStakePools.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let code = error["code"] as? Int {
            
            let response: any JSONRPCResponseError
            if code == 2001 {
                response = try QueryLedgerStateEraMismatch.fromJSONData(data)
            } else if code == 2002 {
                response = try QueryLedgerStateUnavailableInCurrentEra.fromJSONData(data)
            } else if code == 2003 {
                response = try QueryLedgerStateAcquiredExpired.fromJSONData(data)
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
