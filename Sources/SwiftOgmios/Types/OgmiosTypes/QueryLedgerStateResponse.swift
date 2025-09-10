// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let queryLedgerStateResponse = try? newJSONDecoder().decode(QueryLedgerStateResponse.self, from: jsonData)

import Foundation

// MARK: - QueryLedgerStateResponse
public struct QueryLedgerStateResponse: Codable, Sendable {
    public let oneOf: [QueryLedgerStateConstitutionalCommitteeResponseOneOf]

    public init(oneOf: [QueryLedgerStateConstitutionalCommitteeResponseOneOf]) {
        self.oneOf = oneOf
    }
}
