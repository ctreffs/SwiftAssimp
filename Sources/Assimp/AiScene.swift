//
//  AiScene.swift
//  Assimp
//
//  Created by Christian Treffs on 19.06.19.
//

import CAssimp

public class AiScene {
    public enum Error: Swift.Error {
        case importFailed(String)
    }

    fileprivate var _scene: aiScene

    public init(file filePath: String) throws {

        guard let scenePtr = aiImportFile(filePath, 0) else {
            throw Error.importFailed(filePath)
        }

        _scene = scenePtr.pointee
    }

    deinit {
        aiReleaseImport(&_scene)
    }

    public var numTextures: Int {
        return Int(_scene.mNumTextures)
    }

    public var textures: [AiTexture] {
        return [aiTexture](UnsafeBufferPointer<aiTexture>(start: _scene.mTextures?.pointee,
                                                          count: numTextures)).map { AiTexture($0) }

    }

    public var numMeshes: Int {
        return Int(_scene.mNumMeshes)
    }

    public var meshes: [AiMesh] {
        return [aiMesh](UnsafeBufferPointer<aiMesh>(start: _scene.mMeshes?.pointee,
                                                    count: numMeshes)).map { AiMesh($0) }
    }
}
