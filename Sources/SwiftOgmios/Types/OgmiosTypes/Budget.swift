// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let budget = try? newJSONDecoder().decode(Budget.self, from: jsonData)

import Foundation

// MARK: - Budget
public struct Budget: Codable, Sendable {
    public let memory, cpu: Int

    public init(memory: Int, cpu: Int) {
        self.memory = memory
        self.cpu = cpu
    }
}
