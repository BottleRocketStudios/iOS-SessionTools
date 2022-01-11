// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SessionTools",
    platforms: [.iOS(.v9), .tvOS(.v9), .watchOS(.v2), .macOS(.v10_10)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SessionTools",
            targets: ["SessionTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SessionTools",
            dependencies: ["KeychainAccess"]),
        .testTarget(
            name: "SessionToolsTests",
            dependencies: ["SessionTools"]),
    ]
)
