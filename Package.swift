// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "RealityToolbox",
    platforms: [
        // Relevant platforms.
        .iOS(.v15), .macOS(.v12), .tvOS(.v15), .visionOS(.v1)
    ],
    products: [
        .library(name: "RealityToolbox", targets: ["RealityToolbox"])
    ],
    dependencies: [
        // It's a good thing to keep things relatively
        // independent, but add any dependencies here.
    ],
    targets: [
        .target(
            name: "RealityToolbox",
            dependencies: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
        .testTarget(name: "RealityToolboxTests", dependencies: ["RealityToolbox"]),
    ]
)
