// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SynchronousNetworking",
    products: [
        .library(
            name: "SynchronousNetworking",
            targets: ["SynchronousNetworking"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SynchronousNetworking",
            dependencies: []),
        .testTarget(
            name: "SynchronousNetworkingTests",
            dependencies: ["SynchronousNetworking"]),
    ]
)
