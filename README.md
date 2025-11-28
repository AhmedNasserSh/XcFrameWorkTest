# XCFramework Distribution Example

This project demonstrates how to build and distribute an XCFramework via Swift Package Manager (SPM).

## Structure

*   `Source/`: Contains the source code for the framework.
*   `Package.swift`: The distribution manifest that consumers use to install the binary framework.
*   `build_xcframework.sh`: Script to build the XCFramework and generate the checksum.

## How to Release

1.  **Build the Framework**
    Run the build script to generate the `.xcframework.zip` and compute the checksum:
    ```bash
    ./build_xcframework.sh
    ```
    This will output the checksum at the end.

2.  **Update Package.swift**
    *   Update the `url` to point to your new release asset (e.g. `.../releases/download/1.0.1/ExampleFramework.xcframework.zip`).
    *   Update the `checksum` with the value printed by the build script.
    *   Commit and push the changes.
    *   Tag the commit (e.g., `1.0.1`).
    *   Push the tag.

3.  **Create a GitHub Release**
    *   Go to the "Releases" section on GitHub.
    *   Draft a new release using the tag you just pushed.
    *   **Crucial**: Upload the `build/ExampleFramework.xcframework.zip` file to the release assets.
    *   Publish the release.

## How to Use

Consumers can add this package by using the git URL of this repository:
`https://github.com/AhmedNasserSh/XcFrameWorkTest`

No special sub-paths are needed anymore as `Package.swift` is at the root.
