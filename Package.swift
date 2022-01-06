// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Logs",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_10),
        .macCatalyst(.v13)
    ],
    products: [.library(name: "Logs", targets: ["Logs"])],
    targets: [ .target( name: "Logs", dependencies: [])]
)
