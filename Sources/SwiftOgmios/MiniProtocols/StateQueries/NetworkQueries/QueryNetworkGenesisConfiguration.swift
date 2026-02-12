import Foundation
import Logging

/// Query the genesis configuration of a given era.
public struct QueryNetworkGenesisConfiguration {
    private let client: OgmiosClient
    
    private static let method: String = "queryNetwork/genesisConfiguration"
    private static let jsonrpc: String = JSONRPCVersion
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Params
        public let id: JSONRPCId?
        
        init(id: JSONRPCId? = nil, params: Params) {
            self.id = id
            self.method = QueryNetworkGenesisConfiguration.method
            self.jsonrpc = QueryNetworkGenesisConfiguration.jsonrpc
            self.params = params
        }
    }
    
    // MARK: - Params
    public struct Params: JSONSerializable, Sendable {
        public let era: EraWithGenesis
        
        /// Creates a new Params for querying genesis configuration.
        /// - Parameter era: The era to query genesis configuration for.
        public init(era: EraWithGenesis) {
            self.era = era
        }
    }
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: Result
        public let id: JSONRPCId?
        
        init(result: Result, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = QueryNetworkGenesisConfiguration.method
            self.jsonrpc = QueryNetworkGenesisConfiguration.jsonrpc
        }
    }
    
    // MARK: - Result
    public enum Result: JSONSerializable {
        case invalidGenesis(QueryNetworkInvalidGenesis)
        case byron(GenesisConfigurationByron)
        case shelley(GenesisConfigurationShelley)
        case alonzo(GenesisConfigurationAlonzo)
        case conway(GenesisConfigurationConway)
    }
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil, params: Params) async throws -> Result {
        let response = try await self.execute(id: id, params: params)
        return response.result
    }
    
    public func execute(id: JSONRPCId? = nil, params: Params) async throws -> Response {
        let data = try await self.send(id: id, params: params)
        return try await self.process(data: data)
    }
    
    // MARK: - Private Methods
    private func send(id: JSONRPCId? = nil, params: Params) async throws -> Data {
        let request = Request(id: id, params: params)
        return try await client.sendRequestJSON(request)
    }
    
    private func process(data: Data) async throws -> Response {
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let responseJSON = responseJSON else {
            throw OgmiosError.invalidResponse("Response is not a valid JSON object")
        }
        
        guard let method = responseJSON["method"] as? String,
              method == QueryNetworkGenesisConfiguration.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(QueryNetworkGenesisConfiguration.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let _ = error["code"] as? Int {
            
            let response = try QueryNetworkInvalidGenesis.fromJSONData(data)
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

// MARK: - Codable Implementation for Result

/// Helper struct for peeking at the era field to determine Genesis type
private struct GenesisContainer: Codable {
    let era: String
}

extension QueryNetworkGenesisConfiguration.Result: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try to decode as a Genesis configuration first
        if let genesis = try? container.decode(EraWithGenesisWrapper.self) {
            switch genesis.era {
                case .byron:
                    let byronGenesis = try container.decode(GenesisConfigurationByron.self)
                    self = .byron(byronGenesis)
                case .shelley:
                    let shelleyGenesis = try container.decode(GenesisConfigurationShelley.self)
                    self = .shelley(shelleyGenesis)
                case .alonzo:
                    let alonzoGenesis = try container.decode(GenesisConfigurationAlonzo.self)
                    self = .alonzo(alonzoGenesis)
                case .conway:
                    let conwayGenesis = try container.decode(GenesisConfigurationConway.self)
                    self = .conway(conwayGenesis)
            }
        } else {
            // If not a genesis configuration, it must be an error case
            let invalidGenesis = try container.decode(QueryNetworkInvalidGenesis.self)
            self = .invalidGenesis(invalidGenesis)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .invalidGenesis(let error):
            try container.encode(error)
        case .byron(let genesis):
            try container.encode(genesis)
        case .shelley(let genesis):
            try container.encode(genesis)
        case .alonzo(let genesis):
            try container.encode(genesis)
        case .conway(let genesis):
            try container.encode(genesis)
        }
    }
}
