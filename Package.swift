// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Assimp",
    products: [
        .library(name: "Assimp",
                 targets: ["Assimp"])
    ],
    targets: [
        .target(name: "Assimp", dependencies: ["CAssimp"]),
        .target(name: "CAssimp",
                linkerSettings: [
                    .unsafeFlags(["-LSources/CAssimp/lib/macOS"],
                                 .when(platforms: [.macOS], configuration: nil)),
                    .linkedLibrary("assimp")
                ]),
        .testTarget(name: "AssimpTests",  dependencies: ["Assimp"])
    ],
    cLanguageStandard: .gnu99
)
