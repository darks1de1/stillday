// swift-tools-version: 6.0
import PackageDescription

let v5: [SwiftSetting] = [.swiftLanguageMode(.v5)]

let package = Package(
    name: "Stillday",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "Stillday", targets: ["Stillday"]),
        .library(name: "StilldayWidget", targets: ["StilldayWidget"]),
    ],
    targets: [
        // Code the app and the widget extension both need: the snapshot they share and the Live Activity shape.
        .target(name: "StilldayShared", swiftSettings: v5),
        .target(name: "Stillday", dependencies: ["StilldayShared"], swiftSettings: v5),
        // xtool 1.24.0 dead-strips an extension's own main, leaving an empty stub that cannot be signed
        // (xtool-org/xtool#379, fix proposed in #320). Keeping `_main` is the same fix, applied from our side.
        .target(
            name: "StilldayWidget",
            dependencies: ["StilldayShared"],
            swiftSettings: v5,
            linkerSettings: [.unsafeFlags(["-Xlinker", "-u", "-Xlinker", "_main"])]
        ),
    ]
)
