// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let noncesProperties = try? newJSONDecoder().decode(NoncesProperties.self, from: jsonData)

import Foundation

// MARK: - NoncesProperties
public struct NoncesProperties: Codable, Sendable {
    public let epochNonce, candidateNonce, evolvingNonce, lastEpochLastAncestor: PropertyNames

    public init(epochNonce: PropertyNames, candidateNonce: PropertyNames, evolvingNonce: PropertyNames, lastEpochLastAncestor: PropertyNames) {
        self.epochNonce = epochNonce
        self.candidateNonce = candidateNonce
        self.evolvingNonce = evolvingNonce
        self.lastEpochLastAncestor = lastEpochLastAncestor
    }
}
