# XCFramework Distribution Example

This project demonstrates how to build and distribute an XCFramework via Swift Package Manager (SPM).

## Structure

*   `Source/`: Contains the source code for the framework.
*   `Distribution/`: Contains the `Package.swift` that consumers will use to install the binary framework.
*   `build_xcframework.sh`: Script to build the XCFramework and generate the checksum.

## How to Release

1.  **Build the Framework**
    Run the build script to generate the `.xcframework.zip` and compute the checksum:
    ```bash
    ./build_xcframework.sh
    ```
    This will output the checksum at the end.

2.  **Create a GitHub Release**
    *   Push this repository to GitHub.
    *   Go to the "Releases" section and create a new release (e.g., `1.0.0`).
    *   Upload the `build/ExampleFramework.xcframework.zip` file to the release assets.
    *   Publish the release.

3.  **Update Distribution Package**
    *   Open `Distribution/Package.swift`.
    *   Update the `url` to point to your new release asset:
        `https://github.com/<YOUR_USERNAME>/XcFrameWorkTest/releases/download/1.0.0/ExampleFramework.xcframework.zip`
    *   Update the `checksum` with the value printed by the build script.
    *   Commit and push the changes to `Distribution/Package.swift`.

## How to Use

Consumers can now add your package by using the git URL of this repo (or the specific path if it's a monorepo, though typically the Distribution package is in its own repo or root).

Since this example has the Distribution package in a subdirectory, in a real-world scenario, you would likely have the `Distribution/Package.swift` at the root of a dedicated "distribution" repository.
