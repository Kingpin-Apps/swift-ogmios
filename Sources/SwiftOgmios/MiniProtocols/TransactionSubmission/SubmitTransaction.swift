import Foundation
import Logging

/// Submit a signed and serialized transaction to the network.
public struct SubmitTransaction {
    private let client: OgmiosClient
    
    private static let method: String = "submitTransaction"
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
            self.method = SubmitTransaction.method
            self.jsonrpc = SubmitTransaction.jsonrpc
            self.params = params
        }
    }
    
    // MARK: - Params
    public struct Params: JSONSerializable {
        public let transaction: Transaction
        
        public struct Transaction: JSONSerializable {
            /// CBOR-serialized signed transaction (base16)
            public let cbor: String
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
            self.method = SubmitTransaction.method
            self.jsonrpc = SubmitTransaction.jsonrpc
        }
    }
    
    // MARK: - Result
    public struct Result: JSONSerializable {
        public let transaction: TransactionIdWrapper
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
              method == SubmitTransaction.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(SubmitTransaction.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let code = error["code"] as? Int {
            
            let response: any JSONRPCResponseError
            
            // Handle known non-SubmitTransactionFailure errors first
            if code == -32602 {
                response = try SubmitTransactionDeserialisationError.fromJSONData(data)
            } else {
                // Handle SubmitTransactionFailure errors based on error codes
                response = try createSubmitTransactionErrorResponse(from: data, code: code)
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
    
    /// Creates the appropriate SubmitTransactionError response based on the error code
    private func createSubmitTransactionErrorResponse(from data: Data, code: Int) throws -> any JSONRPCResponseError {
        switch code {
        case 3005:
            let failure = try SubmitTransactionFailureEraMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3100:
            let failure = try SubmitTransactionFailureInvalidSignatories.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3101:
            let failure = try SubmitTransactionFailureMissingSignatories.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3102:
            let failure = try SubmitTransactionFailureMissingScripts.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3103:
            let failure = try SubmitTransactionFailureFailingNativeScript.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3104:
            let failure = try SubmitTransactionFailureExtraneousScripts.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3105:
            let failure = try SubmitTransactionFailureMissingMetadataHash.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3106:
            let failure = try SubmitTransactionFailureMissingMetadata.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3107:
            let failure = try SubmitTransactionFailureMetadataHashMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3108:
            let failure = try SubmitTransactionFailureInvalidMetadata.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3109:
            let failure = try SubmitTransactionFailureMissingRedeemers.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3110:
            let failure = try SubmitTransactionFailureExtraneousRedeemers.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3111:
            let failure = try SubmitTransactionFailureMissingDatums.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3112:
            let failure = try SubmitTransactionFailureExtraneousDatums.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3113:
            let failure = try SubmitTransactionFailureScriptIntegrityHashMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3114:
            let failure = try SubmitTransactionFailureOrphanScriptInputs.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3115:
            let failure = try SubmitTransactionFailureMissingCostModels.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3116:
            let failure = try SubmitTransactionFailureMalformedScripts.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3117:
            let failure = try SubmitTransactionFailureUnknownOutputReference.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3118:
            let failure = try SubmitTransactionFailureOutsideOfValidityInterval.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3119:
            let failure = try SubmitTransactionFailureTransactionTooLarge.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3121:
            let failure = try SubmitTransactionFailureEmptyInputSet.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3122:
            let failure = try SubmitTransactionFailureTransactionFeeTooSmall.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3123:
            let failure = try SubmitTransactionFailureValueNotConserved.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3161:
            let failure = try SubmitTransactionFailureExecutionBudgetOutOfBounds.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3997:
            let failure = try SubmitTransactionFailureUnexpectedMempoolError.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3998:
            let failure = try SubmitTransactionFailureUnrecognizedCertificateType.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3120:
            let failure = try SubmitTransactionFailureValueTooLarge.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3124:
            let failure = try SubmitTransactionFailureNetworkMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3125:
            let failure = try SubmitTransactionFailureInsufficientlyFundedOutputs.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3126:
            let failure = try SubmitTransactionFailureBootstrapAttributesTooLarge.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3127:
            let failure = try SubmitTransactionFailureMintingOrBurningAda.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3128:
            let failure = try SubmitTransactionFailureInsufficientCollateral.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3129:
            let failure = try SubmitTransactionFailureTooManyCollateralInputs.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3130:
            let failure = try SubmitTransactionFailureUnforeseeableSlot.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3131:
            let failure = try SubmitTransactionFailureTooManyCollateralInputs.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3132:
            let failure = try SubmitTransactionFailureMissingCollateralInputs.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3133:
            let failure = try SubmitTransactionFailureNonAdaCollateral.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3134:
            let failure = try SubmitTransactionFailureExecutionUnitsTooLarge.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3135:
            let failure = try SubmitTransactionFailureTotalCollateralMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3136:
            let failure = try SubmitTransactionFailureSpendsMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3137:
            let failure = try SubmitTransactionFailureUnauthorizedVotes.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3138:
            let failure = try SubmitTransactionFailureUnknownGovernanceProposals.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3139:
            let failure = try SubmitTransactionFailureInvalidProtocolParametersUpdate.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3140:
            let failure = try SubmitTransactionFailureUnknownStakePool.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3141:
            let failure = try SubmitTransactionFailureIncompleteWithdrawals.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3142:
            let failure = try SubmitTransactionFailureRetirementTooLate.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3143:
            let failure = try SubmitTransactionFailureStakePoolCostTooLow.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3144:
            let failure = try SubmitTransactionFailureMetadataHashTooLarge.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3145:
            let failure = try SubmitTransactionFailureCredentialAlreadyRegistered.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3146:
            let failure = try SubmitTransactionFailureUnknownCredential.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3147:
            let failure = try SubmitTransactionFailureNonEmptyRewardAccount.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3148:
            let failure = try SubmitTransactionFailureUnknownGenesisKey.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3149:
            let failure = try SubmitTransactionFailureDelegationToNonExistentPool.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3150:
            let failure = try SubmitTransactionFailureInvalidGovernanceProposal.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3152:
            let failure = try SubmitTransactionFailureInvalidTxValidityUpperBound.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3153:
            let failure = try SubmitTransactionFailureAuxiliaryDataHashMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3155:
            let failure = try SubmitTransactionFailureMinimumUtxoValueNotMet.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3156:
            let failure = try SubmitTransactionFailureTransactionSizeTooBig.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3157:
            let failure = try SubmitTransactionFailureNativeScriptNotAllowed.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3158:
            let failure = try SubmitTransactionFailureStakePoolAlreadyRegistered.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3159:
            let failure = try SubmitTransactionFailureTooManyAssetsInOutput.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3160:
            let failure = try SubmitTransactionFailureInvalidValidityRange.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3162:
            let failure = try SubmitTransactionFailureExtraSignatories.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3163:
            let failure = try SubmitTransactionFailureMintValueMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3151:
            let failure = try SubmitTransactionFailureCredentialDepositMismatch.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3154:
            let failure = try SubmitTransactionFailureUnknownConstitutionalCommitteeMember.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3164:
            let failure = try SubmitTransactionFailureConflictingInputsAndReferences.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3165:
            let failure = try SubmitTransactionFailureUnauthorizedGovernanceAction.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3166:
            let failure = try SubmitTransactionFailureReferenceScriptsTooLarge.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3167:
            let failure = try SubmitTransactionFailureUnknownVoters.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        case 3168:
            let failure = try SubmitTransactionFailureEmptyTreasuryWithdrawal.fromJSONData(data)
            return SubmitTransactionError(error: failure)
        default:
            throw OgmiosError.responseError("Unknown SubmitTransactionFailure error code: \(code)")
        }
    }
}
