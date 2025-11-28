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
            url: "https://github.com/AhmedNasserSh/XcFrameWorkTest/releases/download/1.0.3/ExampleFramework.xcframework.zip",
            checksum: "bec65de055d36af00aca536413d400da9327bc271c6b39b347036b447e0341b0"
        )
    ]
)
