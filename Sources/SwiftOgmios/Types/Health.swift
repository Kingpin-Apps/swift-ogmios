import Foundation

// MARK: - Health
public struct Health: JSONSerializable {
    public let startTime: String
    public let lastKnownTip: LastKnownTip
    public let lastTipUpdate: String
    public let networkSynchronization: Double
    public let currentEra: String
    public let metrics: Metrics
    public let connectionStatus: String
    public let currentEpoch, slotInEpoch: Int
    public let version, network: String
}

// MARK: - LastKnownTip
public struct LastKnownTip: JSONSerializable {
    public let slot: Int
    public let id: String
    public let height: Int
}

// MARK: - Metrics
public struct Metrics: JSONSerializable {
    public let activeConnections: Int
    public let runtimeStats: RuntimeStats
    public let sessionDurations: SessionDurations
    public let totalConnections, totalMessages, totalUnrouted: Int
}

// MARK: - RuntimeStats
public struct RuntimeStats: JSONSerializable {
    public let cpuTime, currentHeapSize, gcCPUTime, maxHeapSize: Int

    public enum CodingKeys: String, CodingKey {
        case cpuTime, currentHeapSize
        case gcCPUTime = "gcCpuTime"
        case maxHeapSize
    }
}

// MARK: - SessionDurations
public struct SessionDurations: JSONSerializable {
    public let max, min: Int
    public let mean: Double
}
