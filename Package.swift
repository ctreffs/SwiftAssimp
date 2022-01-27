// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Assimp",
    products: [
        .library(name: "Assimp",
                 type: .static,
                 targets: ["Assimp"])
    ],
    targets: [
        .target(name: "Assimp",
                dependencies: ["CAssimp"]),
        .testTarget(name: "AssimpTests", dependencies: ["Assimp"]),
        .systemLibrary(name: "CAssimp",
                       path: "Sources/CAssimp",
                       pkgConfig: "assimp",
                       providers: [
                        .brew(["assimp"]),
                        .apt(["libassimp-dev"]),
                       ])
    ]
)
