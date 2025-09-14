import Foundation
import SwiftCardanoCore

/// Query the Ada value of the treasury and reserves of the protocol.
public struct QueryLedgerStateTreasuryAndReserves {
    private let client: OgmiosClient
    private static let method: String = "queryLedgerState/treasuryAndReserves"
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
        
        init(id: JSONRPCId? = nil) {
            self.id = id
            self.method = QueryLedgerStateTreasuryAndReserves.method
            self.jsonrpc = QueryLedgerStateTreasuryAndReserves.jsonrpc
            self.params = nil
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
            self.method = QueryLedgerStateTreasuryAndReserves.method
            self.jsonrpc = QueryLedgerStateTreasuryAndReserves.jsonrpc
        }
    }
    
    // MARK: - Result
    public struct Result: JSONSerializable, Sendable {
        public let treasury: ValueAdaOnly
        public let reserves: ValueAdaOnly
    }
    
    // MARK: - Public Methods
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
              method == QueryLedgerStateTreasuryAndReserves.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(QueryLedgerStateTreasuryAndReserves.method) response: \(responseJSON["method"] ?? "nil")")
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
                client.logger.error("Response Error: \(responseJSON)")
                throw OgmiosError
                    .responseError("Ogmios returned an unknown error code: \(code)")
            }
            
            client.logResponseError(response: response)
            throw OgmiosError
                .responseError(
                    "Ogmios returned an error: \(String(describing: response.error?.message))"
                )
        }
        
        let response = try Response.fromJSONData(data)
        client.logResponse(response: response)
        
        return try Response.fromJSONData(data)
    }
}
