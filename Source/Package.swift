// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExampleFramework",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "ExampleFramework",
            type: .dynamic,
            targets: ["ExampleFramework"]),
    ],
    targets: [
        .target(
            name: "ExampleFramework",
            dependencies: [],
            path: "Sources/ExampleFramework"
        ),
        .testTarget(
            name: "ExampleFrameworkTests",
            dependencies: ["ExampleFramework"]
        ),
    ]
)
