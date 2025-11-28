// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExampleFramework",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ExampleFramework",
            targets: ["ExampleFramework"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(
            name: "ExampleFramework",
            url: "https://github.com/AhmedNasserSh/XcFrameWorkTest/releases/download/1.0.1/ExampleFramework.xcframework.zip",
            checksum: "1fb11853e10bfa2fe9d8e4515d20fe1f5b7e6cc24574bd9f9b180f10dedc2386"
        )
    ]
)
