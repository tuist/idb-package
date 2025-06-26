#!/bin/bash
# Build script to create XCFrameworks for IDB components

set -e
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IDB_DIR="$SCRIPT_DIR/idb"
BUILD_DIR="$SCRIPT_DIR/build"
XCFRAMEWORKS_DIR="$SCRIPT_DIR/XCFrameworks"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR"
rm -rf "$XCFRAMEWORKS_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$XCFRAMEWORKS_DIR"

# Check if submodule is initialized
if [ ! -f "$IDB_DIR/FBSimulatorControl.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: idb submodule not initialized"
    echo "Run: git submodule update --init --recursive"
    exit 1
fi

function invoke_xcodebuild() {
    local arguments=$@
    xcodebuild $arguments
}

# Function to create XCFramework from FBSimulatorControl project
function create_xcframework() {
    local framework=$1

    echo "📦 Creating XCFramework for $framework..."

    cd "$IDB_DIR"

    # Build universal framework for macOS (both x86_64 and arm64)
    echo "🔨 Building universal $framework for macOS..."
    invoke_xcodebuild \
        -project FBSimulatorControl.xcodeproj \
        -scheme "$framework" \
        -configuration Release \
        -sdk macosx \
        -destination "generic/platform=macOS" \
        ONLY_ACTIVE_ARCH=NO \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        MACH_O_TYPE=staticlib \
        GCC_TREAT_WARNINGS_AS_ERRORS=NO \
        CLANG_WARN_DOCUMENTATION_COMMENTS=NO \
        build

    # Find the built framework
    local framework_path=$(find ~/Library/Developer/Xcode/DerivedData -name "${framework}.framework" -path "*/Build/Products/Release/*" | head -1)

    if [ ! -d "$framework_path" ]; then
        echo "❌ Framework not found at expected location"
        exit 1
    fi

    echo "📍 Found framework at: $framework_path"

    # Create XCFramework
    xcodebuild -create-xcframework \
        -framework "$framework_path" \
        -output "$XCFRAMEWORKS_DIR/${framework}.xcframework"

    if [ $? -eq 0 ]; then
        echo "✅ Created $XCFRAMEWORKS_DIR/${framework}.xcframework"
    else
        echo "❌ Failed to create XCFramework for $framework"
        exit 1
    fi
}

# Function to create XCFramework from idb_companion workspace
function create_companion_xcframework() {
    local framework=$1

    echo "📦 Creating XCFramework for $framework..."

    cd "$IDB_DIR"

    # Build universal framework for macOS (both x86_64 and arm64)
    # Note: CompanionLib is built as dynamic framework since it contains Swift code with dependencies
    echo "🔨 Building universal $framework for macOS..."
    invoke_xcodebuild \
        -workspace idb_companion.xcworkspace \
        -scheme "$framework" \
        -configuration Release \
        -sdk macosx \
        -destination "generic/platform=macOS" \
        ONLY_ACTIVE_ARCH=NO \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        GCC_TREAT_WARNINGS_AS_ERRORS=NO \
        CLANG_WARN_DOCUMENTATION_COMMENTS=NO \
        build

    # Find the built framework
    local framework_path=$(find ~/Library/Developer/Xcode/DerivedData -name "${framework}.framework" -path "*/Build/Products/Release/*" | head -1)

    if [ ! -d "$framework_path" ]; then
        echo "❌ Framework not found at expected location"
        exit 1
    fi

    echo "📍 Found framework at: $framework_path"

    # Create XCFramework
    xcodebuild -create-xcframework \
        -framework "$framework_path" \
        -output "$XCFRAMEWORKS_DIR/${framework}.xcframework"

    if [ $? -eq 0 ]; then
        echo "✅ Created $XCFRAMEWORKS_DIR/${framework}.xcframework"
    else
        echo "❌ Failed to create XCFramework for $framework"
        exit 1
    fi
}

# Build all frameworks
echo "🚀 Starting XCFramework build process..."

# List of frameworks to build from FBSimulatorControl project
FRAMEWORKS=("FBControlCore" "XCTestBootstrap" "FBSimulatorControl" "FBDeviceControl")

for framework in "${FRAMEWORKS[@]}"; do
    create_xcframework "$framework"
done

echo "✨ Build completed!"
echo "📦 XCFrameworks created in: $XCFRAMEWORKS_DIR"
echo ""
echo "Contents:"
ls -la "$XCFRAMEWORKS_DIR"
