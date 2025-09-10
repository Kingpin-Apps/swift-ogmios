// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eraMismatchProperties = try? newJSONDecoder().decode(EraMismatchProperties.self, from: jsonData)

import Foundation

// MARK: - EraMismatchProperties
public struct EraMismatchProperties: Codable, Sendable {
    public let queryEra, ledgerEra: PropertyNames

    public init(queryEra: PropertyNames, ledgerEra: PropertyNames) {
        self.queryEra = queryEra
        self.ledgerEra = ledgerEra
    }
}
