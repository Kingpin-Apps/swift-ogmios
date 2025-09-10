// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let delegatorsItems = try? newJSONDecoder().decode(DelegatorsItems.self, from: jsonData)

import Foundation

// MARK: - DelegatorsItems
public struct DelegatorsItems: Codable, Sendable {
    public let from, credential, stake: PropertyNames

    public init(from: PropertyNames, credential: PropertyNames, stake: PropertyNames) {
        self.from = from
        self.credential = credential
        self.stake = stake
    }
}
