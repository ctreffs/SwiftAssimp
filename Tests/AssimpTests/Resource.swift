//
//  Resource.swift
//
//
//  Created by Christian Treffs on 21.06.19.
//

import Foundation

enum Resource: String {
    case bunny_obj = "https://graphics.stanford.edu/~mdfisher/Data/Meshes/bunny.obj"
    case duck_dae = "https://raw.githubusercontent.com/assimp/assimp/master/test/models/Collada/duck.dae"
    case box_obj = "https://raw.githubusercontent.com/assimp/assimp/master/test/models/OBJ/box.obj"
    case nier_gltf = "https://gitlab.com/ctreffs/assets/raw/master/models/nier/scene.gltf"
    case busterDrone_gltf = "https://gitlab.com/ctreffs/assets/raw/master/models/buster_drone/scene.gltf"
    case airplane_usdz = "https://developer.apple.com/augmented-reality/quick-look/models/biplane/toy_biplane.usdz"
    case boxTextured_gltf = "https://raw.githubusercontent.com/assimp/assimp/master/test/models/glTF2/BoxTextured-glTF/BoxTextured.gltf"
    case cubeDiffuseTextured_3ds = "https://github.com/assimp/assimp/raw/master/test/models/3DS/cube_with_diffuse_texture.3DS"

    private static let fm = FileManager.default

    enum Error: Swift.Error {
        case invalidURL(String)
    }

    static func resourcesDir() -> URL {
        #if os(Linux)
        // linux does not have .allBundles yet.
        let bundle = Bundle.main
        #else
        guard let bundle = Bundle.allBundles.first(where: { ($0.bundleIdentifier?.contains("Tests") ?? false) }) else {
            fatalError("no test bundle found")
        }
        #endif
        var resourcesURL: URL = bundle.bundleURL
        resourcesURL.deleteLastPathComponent()
        return resourcesURL
    }
    static func load(_ resource: Resource) throws -> URL {
        guard let remoteURL: URL = URL(string: resource.rawValue) else {
            throw Error.invalidURL(resource.rawValue)
        }

        var name: String = remoteURL.pathComponents.reversed().prefix(3).reversed().joined(separator: "_")
        name.append(".")
        name.append(remoteURL.lastPathComponent)

        let localFile: URL = resourcesDir().appendingPathComponent(name)
        if !fm.fileExists(atPath: localFile.path) {
            let data = try Data(contentsOf: remoteURL)
            try data.write(to: localFile)
            print("⬇ Downloaded '\(localFile.path)' ⬇")
        }

        return localFile
    }
}
