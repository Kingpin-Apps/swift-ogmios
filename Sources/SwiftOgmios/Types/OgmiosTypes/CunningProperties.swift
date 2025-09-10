// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cunningProperties = try? newJSONDecoder().decode(CunningProperties.self, from: jsonData)

import Foundation

// MARK: - CunningProperties
public struct CunningProperties: Codable, Sendable {
    public let missingScripts: ExtraneousRedeemers?
    public let validationError: Message?
    public let traces: Traces?
    public let unsuitableOutputReference: PropertyNames?

    public init(missingScripts: ExtraneousRedeemers?, validationError: Message?, traces: Traces?, unsuitableOutputReference: PropertyNames?) {
        self.missingScripts = missingScripts
        self.validationError = validationError
        self.traces = traces
        self.unsuitableOutputReference = unsuitableOutputReference
    }
}
