// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleProperties = try? newJSONDecoder().decode(PurpleProperties.self, from: jsonData)

import Foundation

// MARK: - PurpleProperties
public struct PurpleProperties: Codable, Sendable {
    public let shelley, allegra, mary, alonzo: Message
    public let babbage, conway: Message

    public init(shelley: Message, allegra: Message, mary: Message, alonzo: Message, babbage: Message, conway: Message) {
        self.shelley = shelley
        self.allegra = allegra
        self.mary = mary
        self.alonzo = alonzo
        self.babbage = babbage
        self.conway = conway
    }
}
