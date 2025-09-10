// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fluffyStakePools = try? newJSONDecoder().decode(FluffyStakePools.self, from: jsonData)

import Foundation

// MARK: - FluffyStakePools
public struct FluffyStakePools: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let propertyNames, additionalProperties: PropertyNames

    public init(type: DeserialisationFailureType, propertyNames: PropertyNames, additionalProperties: PropertyNames) {
        self.type = type
        self.propertyNames = propertyNames
        self.additionalProperties = additionalProperties
    }
}
