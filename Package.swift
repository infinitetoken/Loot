// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Loot",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "Loot",
            targets: ["Loot"])
    ],
    targets: [
        .target(
            name: "Loot",
            path: "Sources"),
        .testTarget(
            name: "LootTests",
            dependencies: ["Loot"],
            path: "Tests"),
    ]
)
