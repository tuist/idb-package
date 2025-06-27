# IDB XCFrameworks

This repository provides pre-built XCFrameworks of Facebook's [IDB (iOS Debug Bridge)](https://github.com/facebook/idb) distributed as GitHub releases.

> 📦 **XCFramework Distribution**: We automatically build and distribute XCFrameworks of the IDB frameworks daily via GitHub releases, making it easy to integrate IDB's powerful iOS device automation capabilities into your Swift projects without needing to build from source. **Note: We don't provide a Swift package directly - XCFrameworks are distributed as release assets on GitHub.**

## What is IDB?

IDB (iOS Debug Bridge) is a versatile command-line tool for communicating with iOS Simulators and Devices. It was created by Facebook to provide a unified interface for iOS device automation, testing, and debugging.

### Key Features

- **Device Management**: Connect to and manage iOS devices and simulators
- **App Installation**: Install and manage applications on devices
- **Testing**: Run XCTests and UI tests
- **Debugging**: Access device logs, crash reports, and debugging information
- **File Operations**: Transfer files to and from devices
- **Automation**: Automate device interactions for testing and development

## Why This Package?

Facebook's IDB repository hasn't had releases since August 2022, but the project continues to receive updates and improvements. This package:

- **Provides Regular Releases**: Automatically builds and releases new versions daily
- **Pre-built XCFrameworks**: No need to build from source
- **Swift Package Manager Support**: Easy integration into Swift projects with binary distribution
- **macOS Support**: Optimized for macOS development environments
- **Checksum Verification**: Each release includes SHA-256 checksums for secure package verification

## Installation

### Using GitHub Releases

XCFrameworks are distributed as assets in GitHub releases. You can:

1. **Download manually**: Go to the [Releases page](https://github.com/tuist/idb-package/releases) and download the `.xcframework.zip` files
2. **Use Swift Package Manager**: Create your own Package.swift that references the release assets

### Swift Package Manager Integration

Create a `Package.swift` file that references the XCFrameworks from GitHub releases:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YourProject",
    platforms: [.macOS(.v11)],
    dependencies: [
        // No direct dependency - reference release assets directly
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                "FBControlCore",
                "FBDeviceControl", 
                "FBSimulatorControl",
                "XCTestBootstrap"
            ]
        ),
        .binaryTarget(
            name: "FBControlCore",
            url: "https://github.com/tuist/idb-package/releases/download/2025.06.27.1037/FBControlCore.xcframework.zip",
            checksum: "2efaf134ddb06ff173455c70781099a33b07b591b00ce9b8d9eb60ff8e4cff18"
        ),
        .binaryTarget(
            name: "FBDeviceControl",
            url: "https://github.com/tuist/idb-package/releases/download/2025.06.27.1037/FBDeviceControl.xcframework.zip",
            checksum: "7cedd360bfc69e0f0ae49d09d88297204dda402154464708359a68bda688b753"
        ),
        .binaryTarget(
            name: "FBSimulatorControl",
            url: "https://github.com/tuist/idb-package/releases/download/2025.06.27.1037/FBSimulatorControl.xcframework.zip",
            checksum: "679255259a6fb7f5d49774fde368364d91cc1bf60b0baac6f8fa7172058e0f6d"
        ),
        .binaryTarget(
            name: "XCTestBootstrap",
            url: "https://github.com/tuist/idb-package/releases/download/2025.06.27.1037/XCTestBootstrap.xcframework.zip",
            checksum: "d9ffe80058ce52b95da3dbbd0658ea808e969e9ac0ce8a648a9d34af43bd8f0a"
        )
    ]
)
```

> **Important**: Replace the URLs with the latest release version and use the actual SHA-256 checksums provided in the release notes for security verification.

### Manual Integration in Xcode

1. Download the XCFrameworks from the [Releases page](https://github.com/tuist/idb-package/releases)
2. Extract the `.xcframework.zip` files
3. Drag and drop the `.xcframework` files into your Xcode project
4. Ensure they're properly linked in your target's "Frameworks, Libraries, and Embedded Content" section

## Available XCFrameworks

- **FBControlCore.xcframework**: Core functionality and utilities
- **FBDeviceControl.xcframework**: Device communication and control
- **FBSimulatorControl.xcframework**: iOS Simulator management
- **XCTestBootstrap.xcframework**: XCTest integration and utilities

All frameworks are distributed as XCFrameworks with universal macOS support (both x86_64 and arm64 architectures).

## Usage Example

```swift
import FBControlCore
import FBDeviceControl
import FBSimulatorControl

// Example: Get available devices
let deviceSet = FBDeviceSet.default()
let devices = deviceSet.allDevices()

for device in devices {
    print("Device: \(device.name) - \(device.udid)")
}
```

## Building from Source

If you want to build the XCFrameworks yourself:

```bash
git clone https://github.com/tuist/idb-package.git
cd idb-package
git submodule update --init --recursive
./build.sh
```

This will create XCFrameworks in the `XCFrameworks` directory.

## XCFramework Distribution Details

### Daily Automated Builds
- **Schedule**: Every day at 00:00 UTC
- **Trigger**: Automatic detection of new commits in the upstream IDB repository
- **Manual Trigger**: Available through GitHub Actions UI
- **Skip Logic**: Releases are skipped if no new commits are detected since the previous day

### Release Contents
Each release includes:
- Pre-built XCFrameworks (`.xcframework` files)
- Zipped XCFramework archives for Swift Package Manager
- SHA-256 checksums for security verification
- Changelog with commits since the last release
- Usage instructions with current checksums

### Using XCFrameworks with Swift Package Manager
When consuming XCFrameworks through Swift Package Manager, you need to provide checksums for security verification. These are automatically included in each release's Package.swift and release notes.

## Release Schedule

This package automatically creates new releases every day at 00:00 UTC, incorporating the latest changes from Facebook's IDB repository. If no new commits are detected in the upstream repository since the previous day, the release is automatically skipped.

## Versioning

Releases follow a date-based versioning scheme: `YYYY.MM.DD`

## Requirements

- macOS 11.0+
- Xcode 13.0+
- Swift 5.9+

## Contributing

This is an automated packaging repository. For issues with IDB itself, please report them to the [original IDB repository](https://github.com/facebook/idb).

For issues with this packaging or the build process, please open an issue in this repository.

## License

This package follows the same MIT license as the original IDB project. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Facebook for creating and maintaining IDB
- The original IDB contributors and community

## Related Projects

- [IDB](https://github.com/facebook/idb) - The original IDB project
- [Tuist](https://github.com/tuist/tuist) - Xcode project generation tool