// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stickyProperties = try? newJSONDecoder().decode(StickyProperties.self, from: jsonData)

import Foundation

// MARK: - StickyProperties
public struct StickyProperties: Codable, Sendable {
    public let incompatibleEra, unsupportedEra: PropertyNames?
    public let overlappingOutputReferences: ExtraneousRedeemers?
    public let minimumRequiredEra, currentNodeEra: PropertyNames?
    public let reason: Message?

    public init(incompatibleEra: PropertyNames?, unsupportedEra: PropertyNames?, overlappingOutputReferences: ExtraneousRedeemers?, minimumRequiredEra: PropertyNames?, currentNodeEra: PropertyNames?, reason: Message?) {
        self.incompatibleEra = incompatibleEra
        self.unsupportedEra = unsupportedEra
        self.overlappingOutputReferences = overlappingOutputReferences
        self.minimumRequiredEra = minimumRequiredEra
        self.currentNodeEra = currentNodeEra
        self.reason = reason
    }
}
