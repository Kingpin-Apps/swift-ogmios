import Foundation
import Logging

/// Evaluate execution units of scripts in a well-formed transaction.
public struct EvaluateTransaction {
    private let client: OgmiosClient
    
    private static let method: String = "evaluateTransaction"
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
            self.method = EvaluateTransaction.method
            self.jsonrpc = EvaluateTransaction.jsonrpc
            self.params = params
        }
    }
    
    // MARK: - Params
    public struct Params: JSONSerializable {
        public let transaction: Transaction
        public let additionalUtxo: Utxo?
        
        init(transaction: Transaction, additionalUtxo: Utxo? = nil) {
            self.transaction = transaction
            self.additionalUtxo = additionalUtxo
        }
    }
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: [Result]
        public let id: JSONRPCId?
        
        init(result: [Result], id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = EvaluateTransaction.method
            self.jsonrpc = EvaluateTransaction.jsonrpc
        }
    }
    
    // MARK: - Result
    public struct Result: JSONSerializable {
        public let validator: RedeemerPointer
        public let budget: ExecutionUnits
    }
    
    // MARK: - Public Methods
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
              method == EvaluateTransaction.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(EvaluateTransaction.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let code = error["code"] as? Int {
            
            let response: any JSONRPCResponseError
            
            // Handle known non-EvaluateTransactionFailure errors first
            if code == -32602 {
                response = try EvaluateTransactionDeserialisationError.fromJSONData(data)
            } else {
                // Handle EvaluateTransactionFailure errors based on error codes
                response = try createEvaluateTransactionErrorResponse(from: data, code: code)
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
    
    /// Creates the appropriate EvaluateTransactionError response based on the error code
    private func createEvaluateTransactionErrorResponse(from data: Data, code: Int) throws -> any JSONRPCResponseError {
        switch code {
        case 3000:
            let failure = try EvaluateTransactionFailureIncompatibleEra.fromJSONData(data)
            return EvaluateTransactionError(error: failure)
        case 3001:
            let failure = try EvaluateTransactionFailureUnsupportedEra.fromJSONData(data)
            return EvaluateTransactionError(error: failure)
        case 3002:
            let failure = try EvaluateTransactionFailureOverlappingAdditionalUtxo.fromJSONData(data)
            return EvaluateTransactionError(error: failure)
        case 3003:
            let failure = try EvaluateTransactionFailureNodeTipTooOld.fromJSONData(data)
            return EvaluateTransactionError(error: failure)
        case 3004:
            let failure = try EvaluateTransactionFailureCannotCreateEvaluationContext.fromJSONData(data)
            return EvaluateTransactionError(error: failure)
        case 3010:
            let failure = try EvaluateTransactionFailureScriptExecutionFailure.fromJSONData(data)
            return EvaluateTransactionError(error: failure)
        default:
            throw OgmiosError.responseError("Unknown EvaluateTransactionFailure error code: \(code)")
        }
    }
}

