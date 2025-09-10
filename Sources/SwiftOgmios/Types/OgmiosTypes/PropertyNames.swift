// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let propertyNames = try? newJSONDecoder().decode(PropertyNames.self, from: jsonData)

import Foundation

// MARK: - PropertyNames
public struct PropertyNames: Codable, Sendable {
    public let ref: String

    public enum CodingKeys: String, CodingKey {
        case ref = "$ref"
    }

    public init(ref: String) {
        self.ref = ref
    }
}
