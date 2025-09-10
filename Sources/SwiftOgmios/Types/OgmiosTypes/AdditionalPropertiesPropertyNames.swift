// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let additionalPropertiesPropertyNames = try? newJSONDecoder().decode(AdditionalPropertiesPropertyNames.self, from: jsonData)

import Foundation

// MARK: - AdditionalPropertiesPropertyNames
public struct AdditionalPropertiesPropertyNames: Codable, Sendable {
    public let contentEncoding, pattern: String

    public init(contentEncoding: String, pattern: String) {
        self.contentEncoding = contentEncoding
        self.pattern = pattern
    }
}
