// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let deserialisationFailureProperties = try? newJSONDecoder().decode(DeserialisationFailureProperties.self, from: jsonData)

import Foundation

// MARK: - DeserialisationFailureProperties
public struct DeserialisationFailureProperties: Codable, Sendable {
    public let code: Code
    public let message: Message
    public let data: PurpleData

    public init(code: Code, message: Message, data: PurpleData) {
        self.code = code
        self.message = message
        self.data = data
    }
}
