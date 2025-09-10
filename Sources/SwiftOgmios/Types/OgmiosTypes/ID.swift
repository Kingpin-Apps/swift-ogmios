// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let iD = try? newJSONDecoder().decode(ID.self, from: jsonData)

import Foundation

// MARK: - ID
public struct ID: Codable, Sendable {
    public let description: String

    public init(description: String) {
        self.description = description
    }
}
