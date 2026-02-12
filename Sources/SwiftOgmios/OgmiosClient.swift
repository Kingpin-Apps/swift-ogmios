import Foundation
import Network
import Logging


// MARK: - Transport Protocol

/// Represents the different transport methods supported by SwiftOgmios for JSON-RPC communication.
/// 
/// SwiftOgmios supports both HTTP-based and WebSocket-based transports, with optional TLS encryption.
/// Choose the appropriate transport based on your use case:
/// - HTTP/HTTPS: Best for simple queries and serverless environments
/// - WebSocket/WSS: Required for streaming protocols like chain sync and mempool monitoring
/// 
/// ## Topics
/// 
/// ### Transport Types
/// - ``http(_:)``
/// - ``https(_:)``
/// - ``ws(_:)``
/// - ``wss(_:)``
/// 
/// ## See Also
/// - <doc:TransportTypes>
enum JSONRPCTransport {
    /// HTTP transport for unencrypted communication
    /// - Parameter URL: The HTTP endpoint URL
    case http(URL)
    
    /// HTTPS transport for encrypted communication
    /// - Parameter URL: The HTTPS endpoint URL
    case https(URL)
    
    /// WebSocket transport for unencrypted bidirectional communication
    /// - Parameter URL: The WebSocket endpoint URL
    case ws(URL)
    
    /// WebSocket Secure transport for encrypted bidirectional communication
    /// - Parameter URL: The WebSocket Secure endpoint URL
    case wss(URL)
    
    /// The underlying URL for the transport endpoint
    public var url: URL {
        switch self {
            case .http(let url), .https(let url), .ws(let url), .wss(let url):
                return url
        }
    }
}

/// Protocol for receiving transport-related events from the JSON-RPC connection.
/// 
/// Implement this protocol to receive notifications about connection state changes,
/// incoming responses, and transport errors. This is particularly useful for monitoring
/// connection health and implementing custom logging or metrics collection.
/// 
/// ## Topics
/// 
/// ### Connection Events
/// - ``transportDidConnect()``
/// - ``transportDidDisconnect()``
/// 
/// ### Data Events  
/// - ``transportDidReceiveResponse(_:)``
/// - ``transportDidEncounterError(_:)``
/// 
/// ## See Also
/// - <doc:ErrorHandling>
protocol JSONRPCTransportDelegate: AnyObject, Sendable {
    /// Called when the transport successfully establishes a connection
    func transportDidConnect()
    
    /// Called when the transport connection is closed
    func transportDidDisconnect()
    
    /// Called when a response is received from the server
    /// - Parameter data: The raw response data received
    func transportDidReceiveResponse(_ data: Data)
    
    /// Called when the transport encounters an error
    /// - Parameter error: The error that occurred
    func transportDidEncounterError(_ error: Error)
}

// MARK: - OgmiosClient

/// A Swift client for communicating with Ogmios servers via JSON-RPC.
/// 
/// `OgmiosClient` provides a comprehensive interface to all Ogmios protocols including
/// ledger state queries, chain synchronization, transaction submission, and mempool monitoring.
/// It supports both HTTP and WebSocket transports with automatic connection management.
/// 
/// ## Overview
/// 
/// The client is organized into protocol-specific namespaces that group related operations:
/// - ``ledgerStateQuery``: Query the current ledger state
/// - ``networkQuery``: Query network-level information  
/// - ``chainSync``: Stream blockchain data in real-time
/// - ``transactionSubmission``: Submit and evaluate transactions
/// - ``mempoolMonitor``: Monitor mempool contents and changes
/// 
/// ## Creating a Client
/// 
/// ```swift
/// // HTTP client for simple queries
/// let httpClient = try await OgmiosClient(
///     host: "localhost",
///     port: 1337,
///     secure: false,
///     httpOnly: true
/// )
/// 
/// // WebSocket client for streaming protocols
/// let wsClient = try await OgmiosClient(
///     host: "localhost", 
///     port: 1337,
///     secure: false,
///     httpOnly: false
/// )
/// ```
/// 
/// ## Topics
/// 
/// ### Creating Clients
/// - ``init(host:port:path:secure:httpOnly:rpcVersion:configuration:httpConnection:webSocketConnection:)``
/// 
/// ### Protocol Groups
/// - ``ledgerStateQuery``
/// - ``networkQuery`` 
/// - ``chainSync``
/// - ``transactionSubmission``
/// - ``mempoolMonitor``
/// 
/// ### Connection Management
/// - ``connect(httpConnection:webSocketConnection:)``
/// - ``disconnect()``
/// - ``delegate``
/// 
/// ### Health Monitoring
/// - ``getServerHealth(httpConnection:)``
/// 
/// ## See Also
/// - <doc:GettingStarted>
/// - <doc:TransportTypes>
/// - <doc:ErrorHandling>
public class OgmiosClient: @unchecked Sendable, Loggable {
    
    // MARK: - Properties
    
    private let transport: JSONRPCTransport
    private var session: URLSession {
        return URLSession(configuration: self.configuration)
    }
    
    private var httpConnection: (any HTTPConnectable)?
    private var webSocketConnection: (any WebSocketConnectable)?
    
    /// Optional delegate to receive transport events
    /// 
    /// Set this delegate to receive notifications about connection state changes,
    /// incoming responses, and transport errors.
    /// 
    /// ## See Also
    /// - <doc:ErrorHandling>
    weak var delegate: JSONRPCTransportDelegate?
    
    private let host: String
    private let port: Int
    private let path: String
    private let secure: Bool
    private let httpOnly: Bool
    private let rpcVersion: String
    private let configuration: URLSessionConfiguration
    
    internal let logger: Logger
    
    /// Access to chain synchronization protocols
    /// 
    /// Use this namespace to access real-time blockchain streaming functionality:
    /// - Stream new blocks as they arrive
    /// - Handle blockchain rollbacks
    /// - Find intersection points with the chain
    /// 
    /// Chain sync requires a WebSocket connection and is essential for applications
    /// that need real-time blockchain data.
    /// 
    /// ## Example
    /// ```swift
    /// let client = try await OgmiosClient(httpOnly: false)
    /// 
    /// // Find intersection with chain tip
    /// let intersection = try await client.chainSync.findIntersection.execute(
    ///     points: ["origin"]
    /// )
    /// 
    /// // Stream blocks
    /// let block = try await client.chainSync.nextBlock.execute()
    /// ```
    /// 
    /// ## See Also
    /// - <doc:ChainSynchronization>
    public var chainSync: ChainSync {
        return ChainSync(client: self)
    }
    
    /// Access to ledger state query protocols
    /// 
    /// Use this namespace to query the current state of the Cardano ledger:
    /// - Protocol parameters and network configuration
    /// - UTxO sets and account balances
    /// - Stake pool information and delegation status
    /// - Governance proposals and voting information
    /// 
    /// Ledger state queries work with both HTTP and WebSocket transports.
    /// 
    /// ## Example
    /// ```swift
    /// let client = try await OgmiosClient()
    /// 
    /// // Get current network tip
    /// let tip = try await client.ledgerStateQuery.tip.execute()
    /// print("Current slot: \(tip.result.slot)")
    /// 
    /// // Query protocol parameters
    /// let params = try await client.ledgerStateQuery.protocolParameters.execute()
    /// print("Min fee: \(params.result.minFeeConstant)")
    /// ```
    /// 
    /// ## See Also
    /// - <doc:LedgerStateQueries>
    public var ledgerStateQuery: LedgerStateQuery {
        return LedgerStateQuery(client: self)
    }
    
    /// Access to network-level query protocols
    /// 
    /// Use this namespace to query network-wide information:
    /// - Current blockchain height and tip
    /// - Network genesis configuration
    /// - Network start time and epoch information
    /// 
    /// Network queries work with both HTTP and WebSocket transports.
    /// 
    /// ## Example
    /// ```swift
    /// let client = try await OgmiosClient()
    /// 
    /// // Get network tip
    /// let networkTip = try await client.networkQuery.tip.execute()
    /// 
    /// // Get genesis configuration
    /// let genesis = try await client.networkQuery.genesisConfiguration.execute()
    /// ```
    /// 
    /// ## See Also
    /// - <doc:LedgerStateQueries>
    public var networkQuery: NetworkQuery {
        return NetworkQuery(client: self)
    }
    
    /// Access to transaction submission protocols
    /// 
    /// Use this namespace to submit and evaluate transactions:
    /// - Submit signed transactions to the network
    /// - Evaluate transaction execution and resource usage
    /// - Handle detailed transaction validation errors
    /// 
    /// Transaction submission works with both HTTP and WebSocket transports.
    /// 
    /// ## Example
    /// ```swift
    /// let client = try await OgmiosClient()
    /// 
    /// // Submit a transaction
    /// let result = try await client.transactionSubmission.submitTransaction.execute(
    ///     params: SubmitTransaction.Params(
    ///         transaction: SubmitTransaction.Params.Transaction(
    ///             cbor: "your-transaction-cbor-hex"
    ///         )
    ///     )
    /// )
    /// 
    /// print("Transaction ID: \(result.result.transaction.id)")
    /// ```
    /// 
    /// ## See Also
    /// - <doc:TransactionSubmission>
    public var transactionSubmission: TransactionSubmission {
        return TransactionSubmission(client: self)
    }
    
    /// Access to mempool monitoring protocols
    /// 
    /// Use this namespace to monitor the transaction mempool:
    /// - Acquire and release mempool snapshots
    /// - Check if specific transactions are in mempool
    /// - Stream mempool contents and changes
    /// - Monitor mempool size and statistics
    /// 
    /// Mempool monitoring requires a WebSocket connection for streaming operations.
    /// 
    /// ## Example
    /// ```swift
    /// let client = try await OgmiosClient(httpOnly: false)
    /// 
    /// // Acquire mempool
    /// try await client.mempoolMonitor.acquireMempool.execute()
    /// 
    /// // Check mempool size
    /// let size = try await client.mempoolMonitor.sizeOfMempool.execute()
    /// print("Mempool has \(size.result.currentSize) transactions")
    /// 
    /// // Get all mempool transactions
    /// let transactions = try await client.mempoolMonitor.getMempoolTransactions()
    /// ```
    /// 
    /// ## See Also
    /// - <doc:MempoolMonitoring>
    public var mempoolMonitor: MempoolMonitor {
        return MempoolMonitor(client: self)
    }
    
    // MARK: - Initialization
    
    /// Creates a new OgmiosClient instance and establishes connection to the server.
    /// 
    /// This initializer automatically establishes a connection to the Ogmios server using the specified parameters.
    /// The connection type (HTTP or WebSocket) is determined by the `httpOnly` parameter.
    /// 
    /// - Parameters:
    ///   - host: The hostname or IP address of the Ogmios server. Defaults to "localhost".
    ///   - port: The port number of the Ogmios server. Defaults to 1337.
    ///   - path: Additional path component for the server URL. Defaults to empty string.
    ///   - secure: Whether to use TLS encryption (HTTPS/WSS). Defaults to false.
    ///   - httpOnly: Whether to use HTTP transport only. Set to false for WebSocket support. Defaults to false.
    ///   - rpcVersion: JSON-RPC version to use. Defaults to "2.0".
    ///   - configuration: URLSession configuration for network requests. Defaults to `.default`.
    ///   - httpConnection: Custom HTTP connection implementation for dependency injection. Optional.
    ///   - webSocketConnection: Custom WebSocket connection implementation for dependency injection. Optional.
    ///   
    /// - Throws: 
    ///   - `OgmiosError.connectionError`: If the connection to the server fails
    ///   - `OgmiosError.invalidFormat`: If the server URL cannot be constructed
    ///   
    /// ## Examples
    /// 
    /// ### HTTP Client for Simple Queries
    /// ```swift
    /// let httpClient = try await OgmiosClient(
    ///     host: "localhost",
    ///     port: 1337,
    ///     secure: false,
    ///     httpOnly: true
    /// )
    /// ```
    /// 
    /// ### WebSocket Client for Streaming
    /// ```swift
    /// let wsClient = try await OgmiosClient(
    ///     host: "mainnet.ogmios.example.com",
    ///     port: 443,
    ///     secure: true,  // Use WSS
    ///     httpOnly: false
    /// )
    /// ```
    /// 
    /// ### Custom Network Configuration
    /// ```swift
    /// var config = URLSessionConfiguration.default
    /// config.timeoutIntervalForRequest = 60
    /// config.timeoutIntervalForResource = 300
    /// 
    /// let client = try await OgmiosClient(
    ///     host: "your-server.com",
    ///     port: 1337,
    ///     secure: true,
    ///     configuration: config
    /// )
    /// ```
    /// 
    /// ## See Also
    /// - <doc:GettingStarted>
    /// - <doc:TransportTypes>
    public init(
        host: String = "localhost",
        port: Int = 1337,
        path: String = "",
        secure: Bool = false,
        httpOnly: Bool = false,
        rpcVersion: String = "2.0",
        configuration: URLSessionConfiguration = .default,
        httpConnection: (any HTTPConnectable)? = nil,
        webSocketConnection: (any WebSocketConnectable)? = nil
    ) async throws{
        self.host = host
        self.port = port
        self.path = path
        self.secure = secure
        self.httpOnly = httpOnly
        self.rpcVersion = rpcVersion
        
        if self.httpOnly {
            self.transport = self.secure ?
                .https(URL(string: "https://\(host):\(port)/\(path)")!) :
                .http(URL(string: "http://\(host):\(port)/\(path)")!)
        } else {
            self.transport = self.secure ?
                .wss(URL(string: "wss://\(host):\(port)/\(path)")!) :
                .ws(URL(string: "ws://\(host):\(port)/\(path)")!)
        }
        
        self.configuration = configuration
        
        self.logger = Logger(label: "com.swift-ogmios")
        setupLogging()
        
        try await connect(
            httpConnection: httpConnection,
            webSocketConnection: webSocketConnection
        )
    }
    
    deinit {
        disconnect()
    }
    
    // MARK: - Connection Management
    
    /// Establishes a connection to the Ogmios server.
    /// 
    /// This method is called automatically during initialization but can be used to reconnect
    /// if the connection is lost. The connection type is determined by the transport configuration
    /// set during initialization.
    /// 
    /// - Parameters:
    ///   - httpConnection: Custom HTTP connection implementation for dependency injection. Optional.
    ///   - webSocketConnection: Custom WebSocket connection implementation for dependency injection. Optional.
    ///   
    /// - Throws:
    ///   - `OgmiosError.connectionError`: If the connection attempt fails
    ///   
    /// ## See Also
    /// - ``disconnect()``
    /// - <doc:ErrorHandling>
    public func connect(
        httpConnection: (any HTTPConnectable)? = nil,
        webSocketConnection: (any WebSocketConnectable)? = nil
    ) async throws {
        switch transport {
            case .ws(let url), .wss(let url):
                self.webSocketConnection = webSocketConnection ?? WebSocketConnection(url: url, session: session)
            case .http(let url), .https(let url):
                self.httpConnection = httpConnection ?? HTTPConnection(url: url, session: session)
        }
        delegate?.transportDidConnect()
    }
    
    /// Closes the connection to the Ogmios server.
    /// 
    /// This method cleanly closes the transport connection and notifies the delegate.
    /// For WebSocket connections, this properly closes the WebSocket connection.
    /// For HTTP connections, this cleans up any cached connection state.
    /// 
    /// The connection can be re-established by calling ``connect(httpConnection:webSocketConnection:)``.
    /// 
    /// ## Example
    /// ```swift
    /// let client = try await OgmiosClient()
    /// // ... use client
    /// client.disconnect()
    /// ```
    /// 
    /// ## See Also
    /// - ``connect(httpConnection:webSocketConnection:)``
    public func disconnect() {
        webSocketConnection?.close()
        webSocketConnection = nil
        delegate?.transportDidDisconnect()
    }
        
    /// Sends a JSON-RPC request to the Ogmios server and returns the raw response data.
    /// 
    /// This is a low-level method used internally by the protocol implementations.
    /// Most users should use the higher-level protocol methods instead.
    /// 
    /// - Parameter request: The JSON-RPC request to send
    /// 
    /// - Returns: Raw response data from the server
    /// 
    /// - Throws:
    ///   - `OgmiosError.httpError`: For HTTP transport errors
    ///   - `OgmiosError.websocketError`: For WebSocket transport errors
    ///   - `OgmiosError.encodingError`: If the request cannot be serialized
    ///   - `OgmiosError.connectionError`: If no connection is established
    ///   
    /// ## Example
    /// ```swift
    /// // This is typically used internally
    /// let request = SomeJSONRPCRequest(params: params)
    /// let responseData = try await client.sendRequestJSON(request)
    /// ```
    /// 
    /// ## See Also
    /// - <doc:ErrorHandling>
    public func sendRequestJSON(_ request: any JSONRPCRequest) async throws -> Data {
        let requestJSON = try request.toJSONString()
        
        switch transport {
            case .http(_), .https(_):
                guard let httpConnection = httpConnection else {
                    throw OgmiosError.httpError("HTTPConnection not initiated")
                }
                return try await httpConnection.sendRequest(json: requestJSON)
            case .ws(_), .wss(_):
                guard let webSocketConnection = webSocketConnection else {
                    throw OgmiosError.websocketError("WebSocket not connected")
                }
                return try await webSocketConnection.sendRequest(json: requestJSON)
        }
    }
    
    /// Retrieves the health status of the Ogmios server.
    /// 
    /// This method queries the server's `/health` endpoint to check if the server is running
    /// and responsive. It works regardless of the client's transport configuration by using
    /// an HTTP GET request to the health endpoint.
    /// 
    /// - Parameter httpConnection: Custom HTTP connection for the health check. If not provided,
    ///   a temporary HTTP connection will be created.
    ///   
    /// - Returns: A `Health` object containing server status information
    /// 
    /// - Throws:
    ///   - `OgmiosError.httpError`: If the health endpoint is unreachable
    ///   - `OgmiosError.decodingError`: If the health response cannot be parsed
    ///   - `OgmiosError.connectionError`: If unable to connect to the server
    ///   
    /// ## Example
    /// ```swift
    /// let client = try await OgmiosClient()
    /// 
    /// do {
    ///     let health = try await client.getServerHealth()
    ///     print("Server is healthy: \(health.status)")
    /// } catch {
    ///     print("Health check failed: \(error)")
    /// }
    /// ```
    /// 
    /// ## Use Cases
    /// - Application startup health checks
    /// - Periodic server monitoring
    /// - Load balancer health probes
    /// - Debugging connection issues
    /// 
    /// ## See Also
    /// - <doc:ErrorHandling>
    /// - <doc:AdvancedUsage>
    public func getServerHealth(httpConnection: (any HTTPConnectable)? = nil) async throws -> Health {
        let healthCheckURL: URL
        switch transport {
            case .http(let url), .https(let url):
                healthCheckURL = url.appending(path: "health")
            case .ws(let url):
                healthCheckURL = URL(string: url.absoluteString.replacingOccurrences(of: "ws", with: "http"))!.appendingPathComponent("health")
            case .wss(let url):
                healthCheckURL = URL(string: url.absoluteString.replacingOccurrences(of: "wss", with: "https"))!.appendingPathComponent("health")
        }
        
        let responseData: Data
        if httpConnection == nil {
            responseData = try await HTTPConnection(
                url: healthCheckURL,
                session: session
            ).get(url: healthCheckURL)
        } else {
            responseData = try await httpConnection!.get(url: healthCheckURL)
        }
        
        return try JSONDecoder().decode(Health.self, from: responseData)
    }
}


// MARK: - Extensions for Mini-Protocols

/// Ogmios Client Extensions for mini-protocols
extension OgmiosClient {
    
    /// Namespace for all ledger state query operations.
    /// 
    /// This struct provides access to all available ledger state queries including:
    /// - Network and protocol information
    /// - UTxO queries and account balances  
    /// - Stake pool information and delegation
    /// - Governance and voting data
    /// 
    /// All ledger queries are point-in-time snapshots of the current ledger state.
    /// 
    /// ## Topics
    /// 
    /// ### Network Information
    /// - ``tip``
    /// - ``epoch``
    /// - ``eraStart``
    /// - ``eraSummaries``
    /// 
    /// ### Protocol Parameters
    /// - ``protocolParameters``
    /// - ``proposedProtocolParameters``
    /// 
    /// ### UTxO and Balances
    /// - ``utxo``
    /// - ``rewardAccountSummaries``
    /// 
    /// ### Stake Pools
    /// - ``stakePools``
    /// - ``stakePoolsPerformances``
    /// - ``liveStakeDistribution``
    /// - ``projectedRewards``
    /// 
    /// ### Governance
    /// - ``constitution``
    /// - ``constitutionalCommittee``
    /// - ``delegateRepresentatives``
    /// - ``governanceProposals``
    /// 
    /// ### Advanced Queries
    /// - ``dump``
    /// - ``nonces``
    /// - ``operationalCertificates``
    /// - ``treasuryAndReserves``
    /// 
    /// ## See Also
    /// - <doc:LedgerStateQueries>
    public struct LedgerStateQuery {
        private let client: OgmiosClient
        
        /// Creates a ledger state query namespace for the given client
        /// - Parameter client: The OgmiosClient instance to use for queries
        public init(client: OgmiosClient) {
            self.client = client
        }
        
        public var constitution: QueryLedgerStateConstitution {
            return QueryLedgerStateConstitution(client: self.client)
        }
        
        public var constitutionalCommittee: QueryLedgerStateConstitutionalCommittee {
            return QueryLedgerStateConstitutionalCommittee(client: self.client)
        }
        
        public var delegateRepresentatives: QueryLedgerStateDelegateRepresentatives {
            return QueryLedgerStateDelegateRepresentatives(client: self.client)
        }
        
        public var dump: QueryLedgerStateDump {
            return QueryLedgerStateDump(client: self.client)
        }
        
        public var epoch: QueryLedgerStateEpoch {
            return QueryLedgerStateEpoch(client: self.client)
        }
        
        public var eraStart: QueryLedgerStateEraStart {
            return QueryLedgerStateEraStart(client: self.client)
        }
        
        public var eraSummaries: QueryLedgerStateEraSummaries {
            return QueryLedgerStateEraSummaries(client: self.client)
        }
        
        public var governanceProposals: QueryLedgerStateGovernanceProposals {
            return QueryLedgerStateGovernanceProposals(client: self.client)
        }
        
        public var liveStakeDistribution: QueryLedgerStateLiveStakeDistribution {
            return QueryLedgerStateLiveStakeDistribution(client: self.client)
        }
        
        public var nonces: QueryLedgerStateNonces {
            return QueryLedgerStateNonces(client: self.client)
        }
        
        public var operationalCertificates: QueryLedgerStateOperationalCertificates {
            return QueryLedgerStateOperationalCertificates(client: self.client)
        }
        
        public var projectedRewards: QueryLedgerStateProjectedRewards {
            return QueryLedgerStateProjectedRewards(client: self.client)
        }
        
        public var protocolParameters: QueryLedgerStateProtocolParameters {
            return QueryLedgerStateProtocolParameters(client: self.client)
        }
        
        public var proposedProtocolParameters: QueryLedgerStateProposedProtocolParameters {
            return QueryLedgerStateProposedProtocolParameters(client: self.client)
        }
        
        public var rewardAccountSummaries: QueryLedgerStateRewardAccountSummaries {
            return QueryLedgerStateRewardAccountSummaries(client: self.client)
        }
        
        @available(*, deprecated, renamed: "stakePoolsPerformances", message: "Renamed to stakePoolsPerformances in Ogmios v6.13.0")
        public var rewardsProvenance: QueryLedgerStateRewardsProvenance {
            return QueryLedgerStateRewardsProvenance(client: self.client)
        }
        
        public var stakePools: QueryLedgerStateStakePools {
            return QueryLedgerStateStakePools(client: self.client)
        }
        
        public var stakePoolsPerformances: QueryLedgerStateStakePoolsPerformances {
            return QueryLedgerStateStakePoolsPerformances(client: self.client)
        }
        
        public var tip: QueryLedgerStateTip {
            return QueryLedgerStateTip(client: self.client)
        }
        
        public var treasuryAndReserves: QueryLedgerStateTreasuryAndReserves {
            return QueryLedgerStateTreasuryAndReserves(client: self.client)
        }
        
        public var utxo: QueryLedgerStateUtxo {
            return QueryLedgerStateUtxo(client: self.client)
        }
    }
    
    /// Namespace for network-level query operations.
    /// 
    /// This struct provides access to network-wide information queries including:
    /// - Current blockchain height and tip information
    /// - Network genesis configuration and parameters
    /// - Network start time and epoch details
    /// 
    /// Network queries provide information about the blockchain network as a whole,
    /// rather than the current ledger state.
    /// 
    /// ## Topics
    /// 
    /// ### Network Status
    /// - ``tip``
    /// - ``blockHeight``
    /// - ``startTime``
    /// 
    /// ### Network Configuration
    /// - ``genesisConfiguration``
    /// 
    /// ## See Also
    /// - <doc:LedgerStateQueries>
    public struct NetworkQuery {
        private let client: OgmiosClient
        
        /// Creates a network query namespace for the given client
        /// - Parameter client: The OgmiosClient instance to use for queries
        public init(client: OgmiosClient) {
            self.client = client
        }
        
        public var blockHeight: QueryNetworkBlockHeight {
            return QueryNetworkBlockHeight(client: self.client)
        }
        
        public var genesisConfiguration: QueryNetworkGenesisConfiguration {
            return QueryNetworkGenesisConfiguration(client: self.client)
        }
        
        public var startTime: QueryNetworkStartTime {
            return QueryNetworkStartTime(client: self.client)
        }
        
        public var tip: QueryNetworkTip {
            return QueryNetworkTip(client: self.client)
        }
    }
    
    /// Namespace for chain synchronization protocol operations.
    /// 
    /// This struct provides access to real-time blockchain streaming functionality:
    /// - Find intersection points with the blockchain
    /// - Stream new blocks as they are produced
    /// - Handle blockchain rollbacks automatically
    /// 
    /// Chain sync requires a WebSocket connection and is essential for applications
    /// that need to stay synchronized with the blockchain in real-time.
    /// 
    /// ## Important
    /// Chain sync operations require a WebSocket connection. Ensure your client
    /// is created with `httpOnly: false`.
    /// 
    /// ## Topics
    /// 
    /// ### Chain Navigation
    /// - ``findIntersection``
    /// - ``nextBlock``
    /// 
    /// ## See Also
    /// - <doc:ChainSynchronization>
    /// - <doc:TransportTypes>
    public struct ChainSync {
        private let client: OgmiosClient
        
        /// Creates a chain sync namespace for the given client
        /// - Parameter client: The OgmiosClient instance to use for chain sync operations
        public init(client: OgmiosClient) {
            self.client = client
        }
        
        public var findIntersection: FindIntersection {
            return FindIntersection(client: self.client)
        }
        
        public var nextBlock: NextBlock {
            return NextBlock(client: self.client)
        }
    }
    
    /// Namespace for transaction submission protocol operations.
    /// 
    /// This struct provides access to transaction submission and evaluation functionality:
    /// - Submit signed transactions to the network
    /// - Evaluate transaction execution and resource usage
    /// - Receive detailed validation error information
    /// 
    /// Transaction submission works with both HTTP and WebSocket transports,
    /// making it suitable for both one-off submissions and high-throughput applications.
    /// 
    /// ## Topics
    /// 
    /// ### Transaction Operations
    /// - ``submitTransaction``
    /// - ``evaluateTransaction``
    /// 
    /// ## See Also
    /// - <doc:TransactionSubmission>
    /// - <doc:ErrorHandling>
    public struct TransactionSubmission {
        private let client: OgmiosClient
        
        /// Creates a transaction submission namespace for the given client
        /// - Parameter client: The OgmiosClient instance to use for transaction operations
        public init(client: OgmiosClient) {
            self.client = client
        }
        
        public var submitTransaction: SubmitTransaction {
            return SubmitTransaction(client: self.client)
        }
        
        public var evaluateTransaction: EvaluateTransaction {
            return EvaluateTransaction(client: self.client)
        }
    }
    
    /// Namespace for mempool monitoring protocol operations.
    /// 
    /// This struct provides access to mempool monitoring and transaction tracking functionality:
    /// - Acquire and release mempool snapshots
    /// - Check if specific transactions are in the mempool
    /// - Stream mempool contents and changes
    /// - Monitor mempool size and statistics
    /// 
    /// Most mempool operations require a WebSocket connection, especially streaming operations.
    /// The mempool represents the collection of unconfirmed transactions waiting to be included in blocks.
    /// 
    /// ## Important
    /// Streaming mempool operations require a WebSocket connection. Ensure your client
    /// is created with `httpOnly: false`.
    /// 
    /// ## Topics
    /// 
    /// ### Mempool Management
    /// - ``acquireMempool``
    /// - ``releaseMempool``
    /// 
    /// ### Transaction Queries
    /// - ``hasTransaction``
    /// - ``nextTransaction``
    /// - ``sizeOfMempool``
    /// 
    /// ### Convenience Methods
    /// - ``getMempoolTransactions()``
    /// - ``waitForEmptyMempool(timeoutSeconds:)``
    /// 
    /// ## See Also
    /// - <doc:MempoolMonitoring>
    /// - <doc:TransportTypes>
    public struct MempoolMonitor {
        private let client: OgmiosClient
        
        /// Creates a mempool monitor namespace for the given client
        /// - Parameter client: The OgmiosClient instance to use for mempool operations
        public init(client: OgmiosClient) {
            self.client = client
        }
        
        public var acquireMempool: AcquireMempool {
            return AcquireMempool(client: self.client)
        }
        
        public var hasTransaction: HasTransaction {
            return HasTransaction(client: self.client)
        }
        
        public var nextTransaction: NextTransaction {
            return NextTransaction(client: self.client)
        }
        
        public var releaseMempool: ReleaseMempool {
            return ReleaseMempool(client: self.client)
        }
        
        public var sizeOfMempool: SizeOfMempool {
            return SizeOfMempool(client: self.client)
        }
        
        /// Retrieves all transactions currently in the mempool.
        /// 
        /// This convenience method automatically handles the mempool acquisition/release cycle
        /// and collects all transactions in a single operation. It's equivalent to manually
        /// acquiring the mempool, iterating through all transactions, and releasing it.
        /// 
        /// - Returns: An array of all transactions currently in the mempool
        /// 
        /// - Throws:
        ///   - `OgmiosError.websocketError`: If using HTTP-only client (WebSocket required)
        ///   - `OgmiosError.responseError`: If the server returns an error
        ///   - `OgmiosError.connectionError`: If the connection is lost during operation
        ///   
        /// ## Example
        /// ```swift
        /// let client = try await OgmiosClient(httpOnly: false)
        /// 
        /// let transactions = try await client.mempoolMonitor.getMempoolTransactions()
        /// print("Found \(transactions.count) transactions in mempool")
        /// 
        /// for transaction in transactions {
        ///     // Process each transaction
        ///     print("Transaction: \(transaction.id)")
        /// }
        /// ```
        /// 
        /// ## See Also
        /// - ``acquireMempool``
        /// - ``nextTransaction`` 
        /// - ``releaseMempool``
        /// - <doc:MempoolMonitoring>
        public func getMempoolTransactions() async throws -> [NextTransactionResult] {
            let _ = try await acquireMempool.execute()
            
            var transactions: [NextTransactionResult] = []
            while true {
                let response = try await nextTransaction.execute(
                    id: JSONRPCId.generateNextNanoId()
                )
                
                if case .noMoreTransactions = response.result.transaction {
                    break
                } else {
                    transactions.append(response.result.transaction)
                }
            }
            let _ = try await releaseMempool.execute()
            return transactions
        }
        
        /// Waits for the mempool to become empty within the specified timeout.
        /// 
        /// This convenience method continuously monitors the mempool until it becomes empty
        /// or the timeout is reached. It's useful for testing scenarios or applications that
        /// need to wait for all pending transactions to be processed.
        /// 
        /// - Parameter timeoutSeconds: Maximum time to wait for empty mempool. Defaults to 60 seconds.
        /// 
        /// - Throws:
        ///   - `OgmiosError.timeoutError`: If the mempool doesn't empty within the timeout
        ///   - `OgmiosError.websocketError`: If using HTTP-only client (WebSocket required)
        ///   - `OgmiosError.responseError`: If the server returns an error
        ///   - `OgmiosError.connectionError`: If the connection is lost during operation
        ///   
        /// ## Example
        /// ```swift
        /// let client = try await OgmiosClient(httpOnly: false)
        /// 
        /// // Submit some transactions...
        /// 
        /// // Wait for mempool to clear
        /// do {
        ///     try await client.mempoolMonitor.waitForEmptyMempool(timeoutSeconds: 120)
        ///     print("Mempool is now empty")
        /// } catch OgmiosError.timeoutError {
        ///     print("Mempool didn't empty within timeout")
        /// }
        /// ```
        /// 
        /// ## Use Cases
        /// - Test suite cleanup
        /// - Batch processing completion
        /// - Network congestion monitoring
        /// 
        /// ## See Also
        /// - ``getMempoolTransactions()``
        /// - ``sizeOfMempool``
        /// - <doc:MempoolMonitoring>
        public func waitForEmptyMempool(timeoutSeconds: TimeInterval = 60.0) async throws {
            let startTime = Date().timeIntervalSince1970
            while true {
                let _ = try await acquireMempool.execute()
                
                let response = try await nextTransaction.execute(
                    id: JSONRPCId.generateNextNanoId()
                )
                
                if case .noMoreTransactions = response.result.transaction {
                    break
                }
                
                if Date().timeIntervalSince1970 - startTime > timeoutSeconds {
                    throw OgmiosError.timeoutError("Mempool did not empty within the timeout period")
                }
                
                try await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 second
            }
        }
    }
}
