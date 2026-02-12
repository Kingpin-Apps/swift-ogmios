import Foundation

/// Comprehensive error types for SwiftOgmios operations.
/// 
/// `OgmiosError` represents all possible error conditions that can occur when using
/// SwiftOgmios to communicate with an Ogmios server. Each error case includes an optional
/// message with additional context about the failure.
/// 
/// ## Overview
/// 
/// Errors are categorized by their origin:
/// - **Transport Errors**: Connection, HTTP, WebSocket issues
/// - **Protocol Errors**: JSON-RPC format and method errors  
/// - **Data Errors**: Encoding, decoding, and format issues
/// - **Server Errors**: Ogmios server response errors
/// - **Timeout Errors**: Operation timeout errors
/// 
/// ## Error Handling Strategy
/// 
/// ```swift
/// do {
///     let response = try await client.ledgerStateQuery.tip.execute()
///     // Handle success
/// } catch let error as OgmiosError {
///     switch error {
///     case .connectionError(let message):
///         // Retry or switch to backup server
///         print("Connection failed: \(message ?? "Unknown")")
///     case .timeoutError(let message):
///         // Retry with longer timeout
///         print("Request timed out: \(message ?? "Unknown")")
///     case .responseError(let message):
///         // Handle server-side error
///         print("Server error: \(message ?? "Unknown")")
///     default:
///         // Handle other errors
///         print("Operation failed: \(error.description)")
///     }
/// }
/// ```
/// 
/// ## Topics
/// 
/// ### Transport Errors
/// - ``connectionError(_:)``
/// - ``httpError(_:)``
/// - ``websocketError(_:)``
/// 
/// ### Protocol Errors
/// - ``invalidMethodError(_:)``
/// - ``invalidResponse(_:)``
/// - ``responseError(_:)``
/// 
/// ### Data Errors
/// - ``decodingError(_:)``
/// - ``encodingError(_:)``
/// - ``invalidFormat(_:)``
/// - ``invalidJSONError(_:)``
/// - ``invalidLength(_:)``
/// 
/// ### Timeout Errors
/// - ``timeoutError(_:)``
/// 
/// ## See Also
/// - <doc:ErrorHandling>
public enum OgmiosError: Error, CustomStringConvertible, Equatable {
    /// Connection to the Ogmios server failed
    /// - Parameter String?: Optional error message with additional context
    case connectionError(String?)
    
    /// Failed to decode server response data
    /// - Parameter String?: Optional error message with decoding details
    case decodingError(String?)
    
    /// Failed to encode request data
    /// - Parameter String?: Optional error message with encoding details
    case encodingError(String?)
    
    /// HTTP transport layer error
    /// - Parameter String?: Optional error message with HTTP details
    case httpError(String?)
    
    /// Data format validation error
    /// - Parameter String?: Optional error message with format details
    case invalidFormat(String?)
    
    /// JSON parsing or validation error
    /// - Parameter String?: Optional error message with JSON details
    case invalidJSONError(String?)
    
    /// Data length validation error
    /// - Parameter String?: Optional error message with length details
    case invalidLength(String?)
    
    /// JSON-RPC method name validation error
    /// - Parameter String?: Optional error message with method details
    case invalidMethodError(String?)
    
    /// Server response format validation error
    /// - Parameter String?: Optional error message with response details
    case invalidResponse(String?)
    
    /// Ogmios server returned an error response
    /// - Parameter String?: Optional error message from the server
    case responseError(String?)
    
    /// Operation exceeded timeout limit
    /// - Parameter String?: Optional error message with timeout details
    case timeoutError(String?)
    
    /// WebSocket transport layer error
    /// - Parameter String?: Optional error message with WebSocket details
    case websocketError(String?)
    
    /// Human-readable description of the error.
    /// 
    /// Returns the specific error message if available, or a default description
    /// for the error type. This property is used for logging, debugging, and 
    /// user-facing error messages.
    /// 
    /// ## Example
    /// ```swift
    /// catch let error as OgmiosError {
    ///     print("Error occurred: \(error.description)")
    ///     // Log the error for debugging
    ///     logger.error("Ogmios operation failed", metadata: ["error": "\(error.description)"])
    /// }
    /// ```
    public var description: String {
        switch self {
            case .connectionError(let message):
                return message ?? "Connection error"
            case .decodingError(let message):
                return message ?? "Decoding error"
            case .encodingError(let message):
                return message ?? "Encoding error"
            case .httpError(let message):
                return message ?? "HTTP error"
            case .invalidFormat(let message):
                return message ?? "Invalid format error"
            case .invalidJSONError(let message):
                return message ?? "Invalid JSON error"
            case .invalidLength(let message):
                return message ?? "Invalid length error"
            case .invalidMethodError(let message):
                return message ?? "Invalid method error"
            case .invalidResponse(let message):
                return message ?? "Invalid response error"
            case .responseError(let message):
                return message ?? "Ogmios response error"
            case .timeoutError(let message):
                return message ?? "Ogmios timeout error"
            case .websocketError(let message):
                return message ?? "Websocket response error"
        }
    }
}

