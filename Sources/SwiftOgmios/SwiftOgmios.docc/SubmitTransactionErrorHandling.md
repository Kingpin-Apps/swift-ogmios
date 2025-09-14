# SubmitTransaction Enhanced Error Handling

The `SubmitTransaction` process method returns the appropriate `SubmitTransactionError` based on the error code received from Ogmios.

## Supported Error Codes

The following SubmitTransactionFailure error codes are handled:

### Era and Signature Errors
- **3005**: `SubmitTransactionFailureEraMismatch` - Failed to submit in current era
- **3100**: `SubmitTransactionFailureInvalidSignatories` - Invalid signatures  
- **3101**: `SubmitTransactionFailureMissingSignatories` - Missing required signatures

### Script and Witness Errors
- **3102**: `SubmitTransactionFailureMissingScripts` - Missing script witnesses
- **3103**: `SubmitTransactionFailureFailingNativeScript` - Failing native scripts
- **3104**: `SubmitTransactionFailureExtraneousScripts` - Unnecessary scripts included

### Metadata Errors
- **3105**: `SubmitTransactionFailureMissingMetadataHash` - Missing metadata hash
- **3106**: `SubmitTransactionFailureMissingMetadata` - Missing metadata
- **3107**: `SubmitTransactionFailureMetadataHashMismatch` - Metadata hash mismatch
- **3108**: `SubmitTransactionFailureInvalidMetadata` - Invalid metadata format

### Redeemer and Datum Errors
- **3109**: `SubmitTransactionFailureMissingRedeemers` - Missing Plutus redeemers
- **3110**: `SubmitTransactionFailureExtraneousRedeemers` - Unnecessary redeemers
- **3111**: `SubmitTransactionFailureMissingDatums` - Missing Plutus datums
- **3112**: `SubmitTransactionFailureExtraneousDatums` - Unnecessary datums

### Script Integrity and Validation Errors
- **3113**: `SubmitTransactionFailureScriptIntegrityHashMismatch` - Script integrity hash mismatch
- **3114**: `SubmitTransactionFailureOrphanScriptInputs` - Unspendable script inputs
- **3115**: `SubmitTransactionFailureMissingCostModels` - Missing cost models for Plutus versions
- **3116**: `SubmitTransactionFailureMalformedScripts` - Invalid Plutus script encoding

### UTxO and Validation Errors
- **3117**: `SubmitTransactionFailureUnknownOutputReference` - Unknown UTxO references
- **3118**: `SubmitTransactionFailureOutsideOfValidityInterval` - Outside validity time window
- **3119**: `SubmitTransactionFailureTransactionTooLarge` - Transaction exceeds size limit

### Input and Fee Errors
- **3121**: `SubmitTransactionFailureEmptyInputSet` - No transaction inputs
- **3122**: `SubmitTransactionFailureTransactionFeeTooSmall` - Insufficient transaction fee
- **3123**: `SubmitTransactionFailureValueNotConserved` - Input/output value mismatch

### Execution and System Errors
- **3161**: `SubmitTransactionFailureExecutionBudgetOutOfBounds` - Plutus execution budget exceeded
- **3997**: `SubmitTransactionFailureUnexpectedMempoolError` - Custom mempool rejection
- **3998**: `SubmitTransactionFailureUnrecognizedCertificateType` - Invalid certificate type

## Usage

When calling `SubmitTransaction.execute()`, any error response will be properly decoded into the corresponding typed `SubmitTransactionError<T>` where `T` is the specific failure type:

```swift
do {
    let response = try await submitTransaction.execute(
        id: .generateNextNanoId(),
        params: params
    )
    // Success - transaction submitted
} catch {
    if let ogmiosError = error as? OgmiosError {
        // The error will contain detailed information about the specific failure
        print("Transaction failed: \(ogmiosError.localizedDescription)")
    }
}
```

## Implementation Details

The `createSubmitTransactionErrorResponse` method uses a switch statement to map error codes to their corresponding failure types, ensuring type-safe error handling while maintaining the flexibility of the generic `SubmitTransactionError<T>` structure.
