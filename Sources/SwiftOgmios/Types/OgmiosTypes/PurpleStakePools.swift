// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleStakePools = try? newJSONDecoder().decode(PurpleStakePools.self, from: jsonData)

import Foundation

// MARK: - PurpleStakePools
public struct PurpleStakePools: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let propertyNames: PropertyNames
    public let additionalProperties: StakePoolsAdditionalProperties

    public init(type: DeserialisationFailureType, propertyNames: PropertyNames, additionalProperties: StakePoolsAdditionalProperties) {
        self.type = type
        self.propertyNames = propertyNames
        self.additionalProperties = additionalProperties
    }
}
