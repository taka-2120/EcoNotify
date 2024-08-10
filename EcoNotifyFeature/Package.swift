// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EcoNotifyFeature",
    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EcoNotifyFeature",
            targets: ["EcoNotifyFeature"]),
    ],
    dependencies: [
        .package(
            name: "EcoNotifyCore",
            path: "EcoNotifyCore"),
        .package(
            name: "EcoNotifyEntity",
            path: "EcoNotifyEntity"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EcoNotifyFeature",
            dependencies: ["EcoNotifyCore", "EcoNotifyEntity"]
        ),
        .testTarget(
            name: "EcoNotifyFeatureTests",
            dependencies: ["EcoNotifyFeature"]
        ),
    ]
)
