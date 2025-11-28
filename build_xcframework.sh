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

# 1. Archive for iOS
echo "Archiving for iOS..."
xcodebuild archive \
  -scheme "$FRAMEWORK_NAME" \
  -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/ios.xcarchive" \
  -sdk iphoneos \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  -quiet

# 2. Archive for Simulator
echo "Archiving for Simulator..."
xcodebuild archive \
  -scheme "$FRAMEWORK_NAME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/sim.xcarchive" \
  -sdk iphonesimulator \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  -quiet

# 3. Generate Module Map Manually if missing
# XCFrameworks from SPM packages built with xcodebuild archive often miss the .swiftmodule in the framework bundle.
# We will assume standard Swift module structure.

IOS_FW_PATH="$BUILD_DIR/ios.xcarchive/Products/usr/local/lib/$FRAMEWORK_NAME.framework"
SIM_FW_PATH="$BUILD_DIR/sim.xcarchive/Products/usr/local/lib/$FRAMEWORK_NAME.framework"

# Verify if Modules folder exists, if not, we have a problem.
# We can try to build using `swift build` to get the modules if xcodebuild fails.

# 4. Create XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$IOS_FW_PATH" \
  -framework "$SIM_FW_PATH" \
  -output "$BUILD_DIR/$FRAMEWORK_NAME.xcframework"

# Zip
echo "Zipping XCFramework..."
cd "$BUILD_DIR"
zip -r "$FRAMEWORK_NAME.xcframework.zip" "$FRAMEWORK_NAME.xcframework"

# Checksum
echo "Computing Checksum..."
CHECKSUM=$(swift package compute-checksum "$FRAMEWORK_NAME.xcframework.zip")
echo "Checksum: $CHECKSUM"
