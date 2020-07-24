// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Assimp",
    products: [
        .library(name: "Assimp",
                 targets: ["Assimp"])
    ],
    targets: [
        .target(name: "Assimp",
                dependencies: ["CAssimp"]),
        .target(name: "CAssimp"),
        .testTarget(name: "AssimpTests", 
            dependencies: ["Assimp"]),
    ],
    cxxLanguageStandard: .gnucxx11
)
