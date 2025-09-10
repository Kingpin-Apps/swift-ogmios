// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let parametersProperties = try? newJSONDecoder().decode(ParametersProperties.self, from: jsonData)

import Foundation

// MARK: - ParametersProperties
public struct ParametersProperties: Codable, Sendable {
    public let cost, margin, pledge: PropertyNames

    public init(cost: PropertyNames, margin: PropertyNames, pledge: PropertyNames) {
        self.cost = cost
        self.margin = margin
        self.pledge = pledge
    }
}
