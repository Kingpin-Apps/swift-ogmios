import Foundation
import Logging


/// Query currently active governance proposals, optionally restricted to specific governance proposal references.
public struct QueryLedgerStateGovernanceProposals {
    private let client: OgmiosClient
    
    private static let method: String = "queryLedgerState/governanceProposals"
    private static let jsonrpc: String = JSONRPCVersion
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Params?
        public let id: JSONRPCId?
        
        init(id: JSONRPCId? = nil, params: Params? = nil) {
            self.id = id
            self.method = QueryLedgerStateGovernanceProposals.method
            self.jsonrpc = QueryLedgerStateGovernanceProposals.jsonrpc
            self.params = params
        }
    }
    
    // MARK: - Params
    public struct Params: JSONSerializable, Sendable {
        public let proposals: [GovernanceProposalReference]
    }
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: [GovernanceProposalState]
        public let id: JSONRPCId?
        
        init(result: [GovernanceProposalState], id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = QueryLedgerStateGovernanceProposals.method
            self.jsonrpc = QueryLedgerStateGovernanceProposals.jsonrpc
        }
    }
    
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil) async throws -> [GovernanceProposalState] {
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
                method == QueryLedgerStateGovernanceProposals.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(QueryLedgerStateGovernanceProposals.method) response: \(responseJSON["method"] ?? "nil")")
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
