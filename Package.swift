// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitHub",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GitHub",
            targets: ["GitHub"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/http.git", from: "3.0.0"),
        .package(url: "https://github.com/Ponyboy47/URITemplate.swift.git", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "GitHub",
            dependencies: ["HTTP", "URITemplate"]),
        .testTarget(
            name: "GitHubTests",
            dependencies: ["GitHub"]),
    ]
)
