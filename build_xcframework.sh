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

# 3. Manual Module Fix
echo "Fixing Missing Modules..."

# Helper to find and copy swiftmodule
copy_modules() {
    local archive_path="$1"
    local framework_path="$2"
    local sdk="$3"
    
    echo "Generating modules for $sdk..."
    
    # Since xcodebuild archive didn't put them in the framework, we rebuild just the module interface using swiftc
    # This is a hack but necessary when xcodebuild doesn't behave.
    
    mkdir -p "$framework_path/Modules"
    
    # We need to find where the swift files are.
    # Using the source directory
    local swift_files=$(find "$SOURCE_DIR/Sources/ExampleFramework" -name "*.swift")
    
    # Determine target triple
    local target=""
    if [ "$sdk" == "iphoneos" ]; then
        target="arm64-apple-ios14.0"
    else
        target="arm64-apple-ios14.0-simulator"
    fi
    
    # Run swiftc to emit the module interface
    # We use -emit-module-only to avoid linking errors and temporary file issues
    xcrun -sdk $sdk swiftc \
        -emit-module \
        -emit-module-path "$framework_path/Modules/$FRAMEWORK_NAME.swiftmodule" \
        -module-name "$FRAMEWORK_NAME" \
        -target "$target" \
        $swift_files
        
    # Also create a module map
    cat > "$framework_path/Modules/module.modulemap" <<EOF
framework module $FRAMEWORK_NAME {
    umbrella header "$FRAMEWORK_NAME.h"
    export *
    module * { export * }
}
EOF
    
    # Create dummy umbrella header if missing
    if [ ! -f "$framework_path/Headers/$FRAMEWORK_NAME.h" ]; then
        mkdir -p "$framework_path/Headers"
        echo "// $FRAMEWORK_NAME.h" > "$framework_path/Headers/$FRAMEWORK_NAME.h"
        echo "//#import <Foundation/Foundation.h>" >> "$framework_path/Headers/$FRAMEWORK_NAME.h"
    fi
}

IOS_FW_PATH="$BUILD_DIR/ios.xcarchive/Products/usr/local/lib/$FRAMEWORK_NAME.framework"
SIM_FW_PATH="$BUILD_DIR/sim.xcarchive/Products/usr/local/lib/$FRAMEWORK_NAME.framework"

copy_modules "$BUILD_DIR/ios.xcarchive" "$IOS_FW_PATH" "iphoneos"
copy_modules "$BUILD_DIR/sim.xcarchive" "$SIM_FW_PATH" "iphonesimulator"

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
