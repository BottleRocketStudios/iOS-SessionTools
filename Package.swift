// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SessionTools",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS("4.2"),
    ],
    products: [
        .library(name: "SessionTools", targets: ["SessionTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.0"),
    ],
    targets: [
        .target(name: "SessionTools", dependencies: ["KeychainAccess"], path: "Sources"),
        .testTarget(name: "SessionToolsTests", dependencies: ["SessionTools"], path: "Tests")
    ]
)
