import Foundation
import Testing
@testable import SwiftOgmios

@Suite("An anchor keeps its URL as written")
struct AnchorTests {
    static let urls: [String] = [
        "https://example.com/pool-metadata.json",
        "https://example.com/a b.json",
        "ipfs://bafkreigh2akiscaildc",
        "https://EXAMPLE.com/%7euser/../x",
        "",
    ]

    @Test("Any text the ledger accepts decodes unchanged", arguments: urls)
    func keepsText(_ url: String) throws {
        let hash = String(repeating: "ab", count: 32)
        let json = try JSONSerialization.data(withJSONObject: ["hash": hash, "url": url])
        let anchor = try JSONDecoder().decode(Anchor.self, from: json)
        #expect(anchor.url == url)
    }
}
