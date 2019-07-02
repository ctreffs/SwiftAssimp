// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Assimp",
    products: [
        .library(
            name: "Assimp",
            type: .static,
            targets: ["Assimp"])
    ],
    dependencies: [
        .package(url: "https://gitlab.com/fireblade/math.git", from: "0.2.1")
    ],
    targets: [
        .target(
            name: "Assimp",
            dependencies: ["CAssimp", "FirebladeMath"]),
        .testTarget(
            name: "AssimpTests",
            dependencies: ["Assimp"]),
        .systemLibrary(
            name: "CAssimp",
            path: "Sources/CAssimp",
            pkgConfig: "assimp",
            providers: [
                .brew(["assimp"]),
                .apt(["libassimp-dev"])
            ])
    ]
)
