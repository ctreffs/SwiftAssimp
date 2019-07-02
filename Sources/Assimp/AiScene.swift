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

    public init(file filePath: String, flags: AiPostProcessStep = []) throws {
        guard let scenePtr = aiImportFile(filePath, flags.rawValue) else {
            throw Error.importFailed(filePath)
        }

        _scene = scenePtr.pointee
    }

    deinit {
        aiReleaseImport(&_scene)
    }

    public var numMeshes: Int {
        return Int(_scene.mNumMeshes)
    }

    public var meshes: [AiMesh] {
        guard numMeshes > 0, let ptr = _scene.mMeshes?.pointee else {
            return []
        }
        return [aiMesh](UnsafeBufferPointer<aiMesh>(start: ptr,
                                                    count: numMeshes)).map { AiMesh($0) }
    }

    public var numMaterials: Int {
        return Int(_scene.mNumMaterials)
    }

    public var materials: [AiMaterial] {
        guard numMaterials > 0, let ptr = _scene.mMaterials?.pointee else {
            return []
        }
        return [aiMaterial](UnsafeBufferPointer<aiMaterial>.init(start: ptr,
                                                          count: numMaterials)).map { AiMaterial($0) }
    }

    public var numTextures: Int {
        return Int(_scene.mNumTextures)
    }

    public var textures: [AiTexture] {
        guard numTextures > 0, let ptr = _scene.mTextures?.pointee else {
            return []
        }
        return [aiTexture](UnsafeBufferPointer<aiTexture>(start: ptr,
                                                          count: numTextures)).map { AiTexture($0) }

    }

    public var numLights: Int {
        return Int(_scene.mNumLights)
    }

    public var lights: [AiLight] {
        guard numLights > 0, let ptr = _scene.mLights?.pointee else {
            return []
        }
        return [aiLight](UnsafeBufferPointer<aiLight>(start: ptr,
                                                      count: numLights)).map { AiLight($0) }
    }
}
