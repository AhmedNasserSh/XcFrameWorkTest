#!/bin/bash
set -e

# Configuration
FRAMEWORK_NAME="ExampleFramework"
ROOT_DIR="$(pwd)"
BUILD_DIR="${ROOT_DIR}/build"
SOURCE_DIR="${ROOT_DIR}/Source"

# Clean
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cd "$SOURCE_DIR"

# Build for iOS Device
echo "Building for iOS Device..."
xcodebuild archive \
    -scheme "$FRAMEWORK_NAME" \
    -destination "generic/platform=iOS" \
    -archivePath "$BUILD_DIR/ios.xcarchive" \
    -sdk iphoneos \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    -quiet

# Build for iOS Simulator
echo "Building for iOS Simulator..."
xcodebuild archive \
    -scheme "$FRAMEWORK_NAME" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$BUILD_DIR/sim.xcarchive" \
    -sdk iphonesimulator \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    -quiet

# Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework "$BUILD_DIR/ios.xcarchive/Products/usr/local/lib/$FRAMEWORK_NAME.framework" \
    -framework "$BUILD_DIR/sim.xcarchive/Products/usr/local/lib/$FRAMEWORK_NAME.framework" \
    -output "$BUILD_DIR/$FRAMEWORK_NAME.xcframework"

# Zip
echo "Zipping XCFramework..."
cd "$BUILD_DIR"
zip -r "$FRAMEWORK_NAME.xcframework.zip" "$FRAMEWORK_NAME.xcframework"

# Checksum
echo "Computing Checksum..."
CHECKSUM=$(swift package compute-checksum "$FRAMEWORK_NAME.xcframework.zip")
echo "Checksum: $CHECKSUM"
echo "Done."

