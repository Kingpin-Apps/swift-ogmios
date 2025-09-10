// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let indecentProperties = try? newJSONDecoder().decode(IndecentProperties.self, from: jsonData)

import Foundation

// MARK: - IndecentProperties
public struct IndecentProperties: Codable, Sendable {
    public let slot, id: PropertyNames

    public init(slot: PropertyNames, id: PropertyNames) {
        self.slot = slot
        self.id = id
    }
}
