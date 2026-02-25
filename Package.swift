// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Tablature",
    platforms: [.macOS(.v12), .iOS(.v15), .visionOS(.v1)],
    products: [.library(name: "Tablature", targets: ["Tablature"])],
    targets: [
        .target(name: "Tablature", dependencies: []),
        .testTarget(name: "TablatureTests", dependencies: ["Tablature"]),
    ]
)
