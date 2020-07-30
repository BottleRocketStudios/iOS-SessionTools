// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SessionTools",
    platforms: [
        .macOS("10.12"),
        .iOS("10.0"),
        .tvOS("10.0"),
        .watchOS("4.2")
    ],
    products: [
        .library(
            name: "SessionTools",
            targets: ["SessionTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.0"),
    ],
    targets: [
        .target(
            name: "SessionTools",
            dependencies: ["KeychainAccess"],
            path: "Sources"),
        .testTarget(
            name: "SessionTools-iOSTests",
            dependencies: ["SessionTools"],
            path: "Tests")
    ]
)
