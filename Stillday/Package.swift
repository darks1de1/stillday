// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Stillday",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "Stillday", targets: ["Stillday"]),
    ],
    targets: [
        .target(name: "Stillday", swiftSettings: [.swiftLanguageMode(.v5)]),
    ]
)
