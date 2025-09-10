// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tipOrOrigin = try? newJSONDecoder().decode(TipOrOrigin.self, from: jsonData)

import Foundation

// MARK: - TipOrOrigin
public struct TipOrOrigin: Codable, Sendable {
    public let oneOf: [PropertyNames]

    public init(oneOf: [PropertyNames]) {
        self.oneOf = oneOf
    }
}
