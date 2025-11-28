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
            url: "https://github.com/YOUR_GITHUB_USERNAME/XcFrameWorkTest/releases/download/1.0.0/ExampleFramework.xcframework.zip",
            checksum: "f6c08063c512b03a2cc093adce6cc0bcc346193983245645640dbc0b4481430c"
        )
    ]
)
