import Foundation

enum OgmiosError: Error, CustomStringConvertible, Equatable {
    case connectionError(String?)
    case decodingError(String?)
    case encodingError(String?)
    case httpError(String?)
    case invalidFormat(String?)
    case invalidJSONError(String?)
    case invalidLength(String?)
    case invalidMethodError(String?)
    case invalidResponse(String?)
    case responseError(String?)
    case websocketError(String?)
    
    var description: String {
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
            case .websocketError(let message):
                return message ?? "Websocket response error"
        }
    }
}

