// swift-tools-version: 6.1
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
        .package(url: "https://github.com/Kingpin-Apps/swift-cardano-core.git", from: "0.2.23"),
    ],
    targets: [
        .target(
            name: "SwiftOgmios",
            dependencies: [
                .product(name: "SwiftCardanoCore", package: "swift-cardano-core"),
            ]
        ),
        .testTarget(
            name: "SwiftOgmiosTests",
            dependencies: ["SwiftOgmios"]
        ),
    ]
)
