// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let anyECredential = try? newJSONDecoder().decode(AnyECredential.self, from: jsonData)

import Foundation

// MARK: - AnyECredential
public struct AnyECredential: Codable, Sendable {
    public let title: String
    public let oneOf: [AnyDelegateRepresentativeCredentialOneOf]

    public init(title: String, oneOf: [AnyDelegateRepresentativeCredentialOneOf]) {
        self.title = title
        self.oneOf = oneOf
    }
}
