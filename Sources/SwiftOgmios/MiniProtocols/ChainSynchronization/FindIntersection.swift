import Foundation
import Logging


/// Ask for an intersection between the server's local chain and the given points.
public struct FindIntersection {
    private let client: OgmiosClient
    
    private static let method: String = "findIntersection"
    private static let jsonrpc: String = JSONRPCVersion
    
    public init(client: OgmiosClient) {
        self.client = client
    }
    
    // MARK: - Request
    public struct Request: JSONRPCRequest {
        public let jsonrpc: String
        public let method: String
        public let params: Params?
        public let id: JSONRPCId?
        
        public init(id: JSONRPCId? = nil, params: Params? = nil) {
            self.id = id
            self.method = FindIntersection.method
            self.jsonrpc = FindIntersection.jsonrpc
            self.params = params
        }
    }
    
    // MARK: - Params
    public struct Params: JSONSerializable {
        public let points: [PointOrOrigin]
        
        /// Creates a new Params for finding an intersection.
        /// - Parameter points: The points to find intersection with.
        public init(points: [PointOrOrigin]) {
            self.points = points
        }
    }
    
    
    // MARK: - Response
    public struct Response: JSONRPCResponse {
        public let jsonrpc: String
        public let method: String
        public let result: Result
        public let id: JSONRPCId?
        
        public init(result: Result, id: JSONRPCId? = nil) {
            self.result = result
            self.id = id
            self.method = FindIntersection.method
            self.jsonrpc = FindIntersection.jsonrpc
        }
    }
    
    // MARK: - Result
    public struct Result: JSONSerializable {
        public let intersection: PointOrOrigin
        public let tip: TipOrOrigin
    }
    
    // MARK: - Public Methods
    public func result(id: JSONRPCId? = nil, params: Params? = nil) async throws -> Result {
        let response = try await self.execute(id: id, params: params)
        return response.result
    }
    
    public func execute(id: JSONRPCId? = nil, params: Params? = nil) async throws -> Response {
        let data = try await self.send(id: id, params: params)
        return try await self.process(data: data)
    }
    
    // MARK: - Private Methods
    private func send(id: JSONRPCId? = nil, params: Params? = nil) async throws -> Data {
        let request = Request(id: id, params: params)
        return try await client.sendRequestJSON(request)
    }
    
    private func process(data: Data) async throws -> Response {
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let responseJSON = responseJSON else {
            throw OgmiosError.invalidResponse("Response is not a valid JSON object")
        }
        
        guard let method = responseJSON["method"] as? String,
              method == FindIntersection.method else {
            throw OgmiosError.invalidMethodError("Incorrect method for \(FindIntersection.method) response: \(responseJSON["method"] ?? "nil")")
        }
        
        if let error = responseJSON["error"] as? [String: Any],
           let code = error["code"] as? Int {
            
            let response: any JSONRPCResponseError
            
            switch code {
            case 1000:
                let failure = try IntersectionNotFound.fromJSONData(data)
                response = FindIntersectionError(error: failure)
            case 1001:
                let failure = try FindIntersectionIntersectionInterleaved.fromJSONData(data)
                response = FindIntersectionError(error: failure)
            case 4000:
                response = try MustAcquireMempoolFirst.fromJSONData(data)
            default:
                throw OgmiosError
                    .responseError("Ogmios returned an unknown error code: \(code)")
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
}
