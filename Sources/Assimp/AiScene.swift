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
        case importIncomplete(String)
    }

    public struct Flags: OptionSet {
        public var rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static let incomplete = Flags(rawValue: AI_SCENE_FLAGS_INCOMPLETE)
        public static let validated = Flags(rawValue: AI_SCENE_FLAGS_VALIDATED)
        public static let validationWarning = Flags(rawValue: AI_SCENE_FLAGS_VALIDATION_WARNING)
        public static let nonVerboseFormat = Flags(rawValue: AI_SCENE_FLAGS_NON_VERBOSE_FORMAT)
        public static let terrain = Flags(rawValue: AI_SCENE_FLAGS_TERRAIN)
        public static let allowShared = Flags(rawValue: AI_SCENE_FLAGS_ALLOW_SHARED)
    }

    @usableFromInline var scene: aiScene

    public init(file filePath: String, flags: AiPostProcessStep = []) throws {
        guard let scenePtr = aiImportFile(filePath, flags.rawValue) else {
            throw Error.importFailed(String(cString: aiGetErrorString()))
        }

        scene = scenePtr.pointee

        if self.flags.contains(.incomplete) {
            throw Error.importIncomplete(filePath)
        }
    }

    deinit {
        aiReleaseImport(&scene)
    }

    /// Check whether the scene contains meshes
    /// Unless no special scene flags are set this will always be true.
    @inlinable public var hasMeshes: Bool {
        return scene.mMeshes != nil && numMeshes > 0
    }

    /// Check whether the scene contains materials
    /// Unless no special scene flags are set this will always be true.
    @inlinable public var hasMaterials: Bool {
        return scene.mMaterials != nil && numMaterials > 0
    }

    /// Check whether the scene contains lights
    @inlinable public var hasLights: Bool {
        return scene.mLights != nil && numLights > 0
    }

    /// Check whether the scene contains textures
    @inlinable public var hasTextures: Bool {
        return scene.mTextures != nil && numTextures > 0
    }

    /// Check whether the scene contains cameras
    @inlinable public var hasCameras: Bool {
        return scene.mCameras != nil && numCameras > 0
    }

    /// Check whether the scene contains animations
    @inlinable public var hasAnimations: Bool {
        return scene.mAnimations != nil && numAnimations > 0
    }

    /// Any combination of the AI_SCENE_FLAGS_XXX flags.
    ///
    /// By default this value is 0, no flags are set.
    /// Most applications will want to reject all scenes with the AI_SCENE_FLAGS_INCOMPLETE bit set.
    public var flags: Flags {
        return Flags(rawValue: Int32(scene.mFlags))
    }

    /// The root node of the hierarchy.
    ///
    /// There will always be at least the root node if the import was successful (and no special flags have been set).
    /// Presence of further nodes depends on the format and content of the imported file.
    public var rootNode: AiNode {
        guard let node = scene.mRootNode?.pointee else {
            fatalError("There will always be at least the root node if the import was successful (and no special flags have been set)")
        }

        return AiNode(node)
    }

    /// The number of meshes in the scene.
    public var numMeshes: Int {
        return Int(scene.mNumMeshes)
    }

    /// The array of meshes.
    /// Use the indices given in the aiNode structure to access this array.
    /// The array is mNumMeshes in size.
    ///
    /// If the AI_SCENE_FLAGS_INCOMPLETE flag is not set there will always be at least ONE material.
    public var meshes: [AiMesh] {
        guard numMeshes > 0 else {
            return []
        }

        return (0..<numMeshes)
            .compactMap { scene.mMeshes[$0] }
            .map { AiMesh($0.pointee) }
    }

    /// The number of materials in the scene.
    public var numMaterials: Int {
        return Int(scene.mNumMaterials)
    }

    /// The array of materials.
    /// Use the index given in each aiMesh structure to access this array.
    /// The array is mNumMaterials in size.
    ///
    /// If the AI_SCENE_FLAGS_INCOMPLETE flag is not set there will always be at least ONE material.
    ///
    /// <http://assimp.sourceforge.net/lib_html/materials.html>
    public var materials: [AiMaterial] {
        guard numMaterials > 0 else {
            return []
        }

        let materials = (0..<numMaterials)
            .compactMap { scene.mMaterials[$0] }
            .map { AiMaterial($0.pointee) }

        assert(materials.count == numMaterials)

        return materials
    }

    /// The number of animations in the scene.
    public var numAnimations: Int {
        return Int(scene.mNumAnimations)
    }

    /// The array of animations.
    /// All animations imported from the given file are listed here.
    /// The array is mNumAnimations in size.
    public var animations: [aiAnimation] {
        guard numAnimations > 0, let ptr = scene.mAnimations?.pointee else {
            return []
        }
        return [aiAnimation](UnsafeMutableBufferPointer<aiAnimation>(start: ptr,
                                                                     count: numAnimations))
    }

    /// The number of textures embedded into the file
    public var numTextures: Int {
        return Int(scene.mNumTextures)
    }

    /// The array of embedded textures.
    ///
    /// Not many file formats embed their textures into the file.
    /// An example is Quake's MDL format (which is also used by some GameStudio versions)
    public var textures: [AiTexture] {
        guard numTextures > 0, let ptr = scene.mTextures?.pointee else {
            return []
        }
        return [aiTexture](UnsafeMutableBufferPointer<aiTexture>(start: ptr,
                                                                 count: numTextures)).map { AiTexture($0) }
    }

    /// The number of light sources in the scene.
    /// Light sources are fully optional, in most cases this attribute will be 0.
    public var numLights: Int {
        return Int(scene.mNumLights)
    }

    /// The array of light sources.
    /// All light sources imported from the given file are listed here.
    /// The array is mNumLights in size.
    public var lights: [AiLight] {
        guard numLights > 0, let ptr = scene.mLights?.pointee else {
            return []
        }
        return [aiLight](UnsafeMutableBufferPointer<aiLight>(start: ptr,
                                                             count: numLights)).map { AiLight($0) }
    }

    /// The number of cameras in the scene.
    /// Cameras are fully optional, in most cases this attribute will be 0.
    public var numCameras: Int {
        return Int(scene.mNumCameras)
    }

    /// The array of cameras.
    /// All cameras imported from the given file are listed here.
    /// The array is mNumCameras in size.
    /// The first camera in the array (if existing) is the default camera view into the scene.
    public var cameras: [aiCamera] {
        guard numCameras > 0, let ptr = scene.mCameras?.pointee else {
            return []
        }

        return [aiCamera](UnsafeMutableBufferPointer<aiCamera>(start: ptr,
                                                               count: numCameras))
    }
}

extension AiScene {
    @inlinable public func meshes(for node: AiNode) -> [AiMesh] {
        return node.meshes.map { meshes[$0] }
    }
}
