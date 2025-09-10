// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let anyDelegateRepresentativeCredentialOneOf = try? newJSONDecoder().decode(AnyDelegateRepresentativeCredentialOneOf.self, from: jsonData)

import Foundation

// MARK: - AnyDelegateRepresentativeCredentialOneOf
public struct AnyDelegateRepresentativeCredentialOneOf: Codable, Sendable {
    public let ref, title: String?
    public let type: MessageType?
    public let description, contentEncoding, pattern: String?
    public let examples: [String]?

    public enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case title, type, description, contentEncoding, pattern, examples
    }

    public init(ref: String?, title: String?, type: MessageType?, description: String?, contentEncoding: String?, pattern: String?, examples: [String]?) {
        self.ref = ref
        self.title = title
        self.type = type
        self.description = description
        self.contentEncoding = contentEncoding
        self.pattern = pattern
        self.examples = examples
    }
}
