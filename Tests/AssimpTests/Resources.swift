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
    
    static func tmpDir() -> URL {
        let tmpDir: URL
        if #available(OSX 10.12, *) {
            tmpDir = fm.temporaryDirectory
        } else {
            fatalError("needs temp dir")
        }
        return tmpDir
    }
    
    static func load(_ resource: Resource) throws -> URL {
        guard let remoteURL: URL = URL(string: resource.rawValue) else {
            throw Error.invalidURL(resource.rawValue)
        }
        
        let localFile: URL = tmpDir().appendingPathComponent(remoteURL.lastPathComponent)
        if !fm.fileExists(atPath: localFile.path) {
            let data = try Data(contentsOf: remoteURL)
            try data.write(to: localFile, options: .atomicWrite)
        }
        
        return localFile
    }
}
