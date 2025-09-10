// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ambitiousProperties = try? newJSONDecoder().decode(AmbitiousProperties.self, from: jsonData)

import Foundation

// MARK: - AmbitiousProperties
public struct AmbitiousProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: TentacledData

    public init(code: Code, message: Message, data: TentacledData) {
        self.code = code
        self.message = message
        self.data = data
    }
}
