import Foundation
import Network

public protocol HTTPConnectable: Connectable, Sendable {
    func get(url: URL) async throws -> Data
}
    
public final class HTTPConnection: HTTPConnectable {
    private let url: URL
    private let session: URLSession
    
    public init(url: URL, session: URLSession) {
        self.url = url
        self.session = session
    }
    
    public func get(url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (responseData, _) = try await session.data(for: request)
        
        return responseData
    }
    
    public func sendRequest(json: String) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json.data(using: .utf8)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OgmiosError.invalidResponse("Invalid HTTP response: \(String(describing: response))")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            throw OgmiosError.connectionError("HTTP Error: \(httpResponse.statusCode), Response Body: \(responseBody)")
        }
        
        return data
    }
}
