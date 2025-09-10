import Logging
import Foundation

enum LogLevel {
    case debug
    case info
    case warning
    case error
}

// Setup Logging
private let loggingInitOnce: Void = {
    LoggingSystem.bootstrap { label in
        StreamLogHandler.standardOutput(label: label)
    }
}()

protocol Loggable {
    var logger: Logger { get }
}

extension Loggable {
    
    func setupLogging() {
        _ = loggingInitOnce
    }
    
    func logResponse(response: any JSONRPCResponse, logLevel: LogLevel = .debug) {
        let responseType = type(of: response)
        let responseString = (try? response.toJSONString()) ?? String(describing: response)
        
        switch logLevel {
            case .debug:
                logger.debug("Response Type: \(responseType), \nResponse: \(responseString)")
            case .info:
                logger.info("Response Type: \(responseType), \nResponse: \(responseString)")
            case .warning:
                logger.warning("Response Type: \(responseType), \nResponse: \(responseString)")
            case .error:
                logger.error("Response Type: \(responseType), \nResponse: \(responseString)")
        }
    }
    
    func logResponseError(response: any JSONRPCResponseError) {
        let responseType = type(of: response)
        let responseString = (try? response.toJSONString()) ?? String(describing: response)
        
        logger.error("Response Type: \(responseType), \nResponse: \(responseString)")
    }
}
