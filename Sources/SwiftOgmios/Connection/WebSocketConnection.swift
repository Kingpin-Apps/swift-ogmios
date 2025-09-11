import Foundation

public protocol WebSocketConnectable: Connectable, Sendable {
    func close()
}

/// Enumeration of possible errors that might occur while using ``WebSocketConnection``.
public enum WebSocketConnectionError: Error {
    case connectionError
    case transportError
    case encodingError
    case decodingError
    case disconnected
    case closed
}

/// A generic WebSocket Connection over an expected `Incoming` and `Outgoing` message type.
public final class WebSocketConnection: WebSocketConnectable {
    private let webSocketTask: URLSessionWebSocketTask
    private let session: URLSession

    public init(url: URL, session: URLSession) {
        self.session = session
        self.webSocketTask = self.session.webSocketTask(with: url)
        
        self.webSocketTask.maximumMessageSize = 4 * 1024 * 1024 // 4 MB

        webSocketTask.resume()
    }

    deinit {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }

    private func receiveSingleMessage() async throws -> String {
        switch try await webSocketTask.receive() {
            case let .string(message):
                return message
            case let .data(messageData):
                guard let message = String(data: messageData, encoding: .utf8) else {
                    throw WebSocketConnectionError.decodingError
                }
                return message
            @unknown default:
                webSocketTask.cancel(with: .unsupportedData, reason: nil)
                throw WebSocketConnectionError.decodingError
        }
    }
}

// MARK: Public Interface

extension WebSocketConnection {
    public func sendRequest(json: String) async throws -> Data {
        try await self.send(json)
        
        let responseString = try await self.receiveOnce()
        return responseString.data(using: .utf8) ?? Data()
    }
    
    func send(_ message: String) async throws {
        do {
            try await webSocketTask.send(.string(message))
        } catch {
            switch webSocketTask.closeCode {
                case .invalid:
                    throw WebSocketConnectionError.connectionError

                case .goingAway:
                    throw WebSocketConnectionError.disconnected

                case .normalClosure:
                    throw WebSocketConnectionError.closed

                default:
                    throw WebSocketConnectionError.transportError
            }
        }
    }

    func receiveOnce() async throws -> String {
        do {
            return try await receiveSingleMessage()
        } catch {
            switch webSocketTask.closeCode {
                case .invalid:
                    throw WebSocketConnectionError.connectionError

                case .goingAway:
                    throw WebSocketConnectionError.disconnected

                case .normalClosure:
                    throw WebSocketConnectionError.closed

                default:
                    throw WebSocketConnectionError.transportError
            }
        }
    }

    func receive() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { [weak self] in
            guard let self else {
                // Self is gone, return nil to end the stream
                return nil
            }

            let message = try await self.receiveOnce()

            // End the stream (by returning nil) if the calling Task was canceled
            return Task.isCancelled ? nil : message
        }
    }

    public func close() {
        webSocketTask.cancel(with: .normalClosure, reason: nil)
    }
}
