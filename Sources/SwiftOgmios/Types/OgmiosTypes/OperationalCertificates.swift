// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let operationalCertificates = try? newJSONDecoder().decode(OperationalCertificates.self, from: jsonData)

import Foundation

// MARK: - OperationalCertificates
public struct OperationalCertificates: Codable, Sendable {
    public let type: DeserialisationFailureType
    public let description: String
    public let additionalProperties: AdditionalProperties
    public let propertyNames: PropertyNames

    public init(type: DeserialisationFailureType, description: String, additionalProperties: AdditionalProperties, propertyNames: PropertyNames) {
        self.type = type
        self.description = description
        self.additionalProperties = additionalProperties
        self.propertyNames = propertyNames
    }
}
