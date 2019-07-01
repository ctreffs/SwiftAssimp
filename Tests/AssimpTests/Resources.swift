//
//  File.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import Foundation

enum Resource: String {
    case bunny_obj = "https://graphics.stanford.edu/~mdfisher/Data/Meshes/bunny.obj"

    case duck_dae = "https://raw.githubusercontent.com/assimp/assimp/master/test/models/Collada/duck.dae"
    case box_obj = "https://raw.githubusercontent.com/assimp/assimp/master/test/models/OBJ/box.obj"

    private static let fm = FileManager.default

    enum Error: Swift.Error {
        case invalidURL(String)
    }

    static func resourcesDir() -> URL {
        guard let resourcesURL: URL = Bundle.allBundles.first(where: { $0.bundlePath.contains(".xctest") })?.bundleURL else {
            fatalError("no test bundle found")
        }

        return resourcesURL
    }
    static func load(_ resource: Resource) throws -> URL {
        guard let remoteURL: URL = URL(string: resource.rawValue) else {
            throw Error.invalidURL(resource.rawValue)
        }

        let localFile: URL = resourcesDir().appendingPathComponent(remoteURL.lastPathComponent)
        if !fm.fileExists(atPath: localFile.path) {
            let data = try Data(contentsOf: remoteURL)
            try data.write(to: localFile, options: .atomicWrite)
            print("⬇ Downloaded '\(localFile.path)' ⬇")
        }

        return localFile
    }
}
