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

    public init(startTime: String, lastKnownTip: LastKnownTip, lastTipUpdate: String, networkSynchronization: Double, currentEra: String, metrics: Metrics, connectionStatus: String, currentEpoch: Int, slotInEpoch: Int, version: String, network: String) {
        self.startTime = startTime
        self.lastKnownTip = lastKnownTip
        self.lastTipUpdate = lastTipUpdate
        self.networkSynchronization = networkSynchronization
        self.currentEra = currentEra
        self.metrics = metrics
        self.connectionStatus = connectionStatus
        self.currentEpoch = currentEpoch
        self.slotInEpoch = slotInEpoch
        self.version = version
        self.network = network
    }
}

// MARK: - LastKnownTip
public struct LastKnownTip: JSONSerializable {
    public let slot: Int
    public let id: String
    public let height: Int

    public init(slot: Int, id: String, height: Int) {
        self.slot = slot
        self.id = id
        self.height = height
    }
}

// MARK: - Metrics
public struct Metrics: JSONSerializable {
    public let activeConnections: Int
    public let runtimeStats: RuntimeStats
    public let sessionDurations: SessionDurations
    public let totalConnections, totalMessages, totalUnrouted: Int

    public init(activeConnections: Int, runtimeStats: RuntimeStats, sessionDurations: SessionDurations, totalConnections: Int, totalMessages: Int, totalUnrouted: Int) {
        self.activeConnections = activeConnections
        self.runtimeStats = runtimeStats
        self.sessionDurations = sessionDurations
        self.totalConnections = totalConnections
        self.totalMessages = totalMessages
        self.totalUnrouted = totalUnrouted
    }
}

// MARK: - RuntimeStats
public struct RuntimeStats: JSONSerializable {
    public let cpuTime, currentHeapSize, gcCPUTime, maxHeapSize: Int

    public enum CodingKeys: String, CodingKey {
        case cpuTime, currentHeapSize
        case gcCPUTime = "gcCpuTime"
        case maxHeapSize
    }

    public init(cpuTime: Int, currentHeapSize: Int, gcCPUTime: Int, maxHeapSize: Int) {
        self.cpuTime = cpuTime
        self.currentHeapSize = currentHeapSize
        self.gcCPUTime = gcCPUTime
        self.maxHeapSize = maxHeapSize
    }
}

// MARK: - SessionDurations
public struct SessionDurations: JSONSerializable {
    public let max, min: Int
    public let mean: Double

    public init(max: Int, mean: Double, min: Int) {
        self.max = max
        self.mean = mean
        self.min = min
    }
}
