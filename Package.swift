// swift-tools-version:5.1
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
            // we are unable to use pkg config here since assimp has an issue in it's .pc file. See: <https://github.com/assimp/assimp/issues/2804>
            // we could use a custom PKG_CONFIG_PATH to add a custom .pc file (https://stackoverflow.com/a/47107882/6043526) but this is a big hassle.
            // just copy the correct file before compiling!
            pkgConfig: "assimp",
            providers: [
                .brew(["assimp"]),
                .apt(["libassimp-dev"]),
                
        ])
    ]
)
