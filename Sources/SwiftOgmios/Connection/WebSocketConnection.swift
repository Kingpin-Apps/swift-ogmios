import Foundation
import NIOCore
import NIOPosix
import WebSocketKit

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

/// A WebSocket connection backed by Vapor's `WebSocketKit` (swift-nio).
///
/// Works on Apple platforms and Linux without platform gating, replacing the previous
/// `URLSessionWebSocketTask`-based implementation (which is unavailable in
/// swift-corelibs-foundation on Linux).
///
/// The connection is established lazily on the first `sendRequest` call.
public final class WebSocketConnection: WebSocketConnectable {
    private let url: URL
    private let eventLoopGroup: any EventLoopGroup
    private let state: ConnectionState

    public init(
        url: URL,
        eventLoopGroup: any EventLoopGroup = MultiThreadedEventLoopGroup.singleton
    ) {
        self.url = url
        self.eventLoopGroup = eventLoopGroup
        self.state = ConnectionState()
    }

    public func sendRequest(json: String) async throws -> Data {
        try await state.connectIfNeeded(url: url, eventLoopGroup: eventLoopGroup)
        try await state.send(json)
        let response = try await state.receiveOnce()
        return response.data(using: .utf8) ?? Data()
    }

    public func close() {
        let state = self.state
        Task { await state.close() }
    }
}

// MARK: - Internal state

private actor ConnectionState {
    private var webSocket: WebSocket?
    private var pendingMessages: [String] = []
    private var waitingReceivers: [CheckedContinuation<String, Error>] = []
    private var didClose: Bool = false

    func connectIfNeeded(url: URL, eventLoopGroup: any EventLoopGroup) async throws {
        if let ws = webSocket, !ws.isClosed { return }
        if didClose { throw WebSocketConnectionError.closed }

        let promise = eventLoopGroup.any().makePromise(of: WebSocket.self)

        WebSocket.connect(to: url, on: eventLoopGroup) { [weak self] ws in
            let weakState = self
            ws.onText { _, text in
                Task { await weakState?.handleIncoming(text) }
            }
            ws.onClose.whenComplete { _ in
                Task { await weakState?.handleRemoteClose() }
            }
            promise.succeed(ws)
        }.whenFailure { error in
            promise.fail(error)
        }

        do {
            self.webSocket = try await promise.futureResult.get()
        } catch {
            throw WebSocketConnectionError.connectionError
        }
    }

    func send(_ message: String) async throws {
        guard let ws = webSocket, !ws.isClosed else {
            throw WebSocketConnectionError.disconnected
        }
        do {
            try await ws.send(message)
        } catch {
            throw WebSocketConnectionError.transportError
        }
    }

    func receiveOnce() async throws -> String {
        if !pendingMessages.isEmpty {
            return pendingMessages.removeFirst()
        }
        if didClose {
            throw WebSocketConnectionError.closed
        }
        return try await withCheckedThrowingContinuation { continuation in
            waitingReceivers.append(continuation)
        }
    }

    func close() async {
        didClose = true
        for receiver in waitingReceivers {
            receiver.resume(throwing: WebSocketConnectionError.closed)
        }
        waitingReceivers.removeAll()
        pendingMessages.removeAll()
        if let ws = webSocket, !ws.isClosed {
            try? await ws.close()
        }
        webSocket = nil
    }

    // MARK: - Callbacks invoked from NIO event loop

    private func handleIncoming(_ message: String) {
        if let receiver = waitingReceivers.first {
            waitingReceivers.removeFirst()
            receiver.resume(returning: message)
        } else {
            pendingMessages.append(message)
        }
    }

    private func handleRemoteClose() {
        didClose = true
        for receiver in waitingReceivers {
            receiver.resume(throwing: WebSocketConnectionError.disconnected)
        }
        waitingReceivers.removeAll()
        webSocket = nil
    }
}
