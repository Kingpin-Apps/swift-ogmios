// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let braggadociousProperties = try? newJSONDecoder().decode(BraggadociousProperties.self, from: jsonData)

import Foundation

// MARK: - BraggadociousProperties
public struct BraggadociousProperties: Codable, Sendable {
    public let output, minimumRequiredValue: PropertyNames

    public init(output: PropertyNames, minimumRequiredValue: PropertyNames) {
        self.output = output
        self.minimumRequiredValue = minimumRequiredValue
    }
}
