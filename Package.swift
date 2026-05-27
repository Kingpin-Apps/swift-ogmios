// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOgmios",
    platforms: [
      .iOS(.v14),
      .macOS(.v15),
      .watchOS(.v7),
      .tvOS(.v14),
    ],
    products: [
        .library(
            name: "SwiftOgmios",
            targets: ["SwiftOgmios"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kingpin-Apps/swift-cardano-core.git", from: "0.4.0"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.16.2"),
    ],
    targets: [
        .target(
            name: "SwiftOgmios",
            dependencies: [
                .product(name: "SwiftCardanoCore", package: "swift-cardano-core"),
                .product(name: "WebSocketKit", package: "websocket-kit"),
            ]
        ),
        .testTarget(
            name: "SwiftOgmiosTests",
            dependencies: ["SwiftOgmios"]
        ),
    ]
)
