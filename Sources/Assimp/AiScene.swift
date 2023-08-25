//
// AiScene.swift
// SwiftAssimp
//
// Copyright © 2019-2023 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

public final class AiScene {
    public enum Error: Swift.Error {
        case importFailed(String)
        case importIncomplete(String)
        case noRootNode
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

    let scene: aiScene

    public init(file filePath: String, flags: AiPostProcessStep = []) throws {
        guard let scenePtr = aiImportFile(filePath, flags.rawValue) else {
            throw Error.importFailed(String(cString: aiGetErrorString()))
        }
        scene = scenePtr.pointee
        let flags = Flags(rawValue: Int32(scene.mFlags))

        if flags.contains(.incomplete) {
            throw Error.importIncomplete(filePath)
        }
        self.flags = flags

        let numMeshes = Int(scene.mNumMeshes)
        self.numMeshes = numMeshes
        let numMaterials = Int(scene.mNumMaterials)
        self.numMaterials = numMaterials
        let numAnimations = Int(scene.mNumAnimations)
        self.numAnimations = numAnimations
        let numTextures = Int(scene.mNumTextures)
        self.numTextures = numTextures
        let numLights = Int(scene.mNumLights)
        self.numLights = numLights
        let numCameras = Int(scene.mNumCameras)
        self.numCameras = numCameras

        hasMeshes = scene.mMeshes != nil && numMeshes > 0
        hasMaterials = scene.mMaterials != nil && numMaterials > 0
        hasLights = scene.mLights != nil && numLights > 0
        hasTextures = scene.mTextures != nil && numTextures > 0
        hasCameras = scene.mCameras != nil && numCameras > 0
        hasAnimations = scene.mAnimations != nil && numAnimations > 0

        guard let node = scene.mRootNode?.pointee else {
            throw Error.noRootNode
        }

        rootNode = AiNode(node)
    }

    deinit {
        withUnsafePointer(to: scene) {
            aiReleaseImport($0)
        }
    }

    /// Check whether the scene contains meshes
    /// Unless no special scene flags are set this will always be true.
    public var hasMeshes: Bool

    /// Check whether the scene contains materials
    /// Unless no special scene flags are set this will always be true.
    public var hasMaterials: Bool

    /// Check whether the scene contains lights
    public var hasLights: Bool

    /// Check whether the scene contains embedded textures
    public var hasTextures: Bool

    /// Check whether the scene contains cameras
    public var hasCameras: Bool

    /// Check whether the scene contains animations
    public var hasAnimations: Bool

    /// Any combination of the AI_SCENE_FLAGS_XXX flags.
    ///
    /// By default this value is 0, no flags are set.
    /// Most applications will want to reject all scenes with the AI_SCENE_FLAGS_INCOMPLETE bit set.
    public var flags: Flags

    /// The root node of the hierarchy.
    ///
    /// There will always be at least the root node if the import was successful (and no special flags have been set).
    /// Presence of further nodes depends on the format and content of the imported file.
    public var rootNode: AiNode

    /// The number of meshes in the scene.
    public var numMeshes: Int

    /// The array of meshes.
    /// Use the indices given in the aiNode structure to access this array.
    /// The array is mNumMeshes in size.
    ///
    /// If the AI_SCENE_FLAGS_INCOMPLETE flag is not set there will always be at least ONE material.
    public lazy var meshes: [AiMesh] = UnsafeBufferPointer(start: scene.mMeshes, count: numMeshes).compactMap { AiMesh($0?.pointee) }

    /// The number of materials in the scene.
    public var numMaterials: Int

    /// The array of materials.
    /// Use the index given in each aiMesh structure to access this array.
    /// The array is mNumMaterials in size.
    ///
    /// If the AI_SCENE_FLAGS_INCOMPLETE flag is not set there will always be at least ONE material.
    ///
    /// <http://assimp.sourceforge.net/lib_html/materials.html>
    public lazy var materials: [AiMaterial] = UnsafeBufferPointer(start: scene.mMaterials, count: numMaterials).compactMap { AiMaterial($0?.pointee) }

    /// The number of animations in the scene.
    public var numAnimations: Int

    /// The array of animations.
    /// All animations imported from the given file are listed here.
    /// The array is mNumAnimations in size.
    //  public var animations: [aiAnimation] {
    //      guard numAnimations > 0 else {
    //          return []
    //      }

    //      let animations = (0..<numAnimations)
    //          .compactMap { scene.mAnimations[$0] }
    //          .map { $0.pointee } // TODO: wrap animations

    //      assert(animations.count == numAnimations)

    //      return animations
    //  }

    /// The number of textures embedded into the file
    public var numTextures: Int

    /// The array of embedded textures.
    ///
    /// Not many file formats embed their textures into the file.
    /// An example is Quake's MDL format (which is also used by some GameStudio versions)
    public lazy var textures = UnsafeBufferPointer(start: scene.mTextures, count: numTextures).compactMap { AiTexture($0?.pointee) }

    /// The number of light sources in the scene.
    /// Light sources are fully optional, in most cases this attribute will be 0.
    public var numLights: Int

    /// The array of light sources.
    /// All light sources imported from the given file are listed here.
    /// The array is mNumLights in size.
    public lazy var lights: [AiLight] = UnsafeBufferPointer(start: scene.mLights, count: numLights).compactMap { AiLight($0?.pointee) }

    /// The number of cameras in the scene.
    /// Cameras are fully optional, in most cases this attribute will be 0.
    public var numCameras: Int

    /// The array of cameras.
    /// All cameras imported from the given file are listed here.
    /// The array is mNumCameras in size.
    /// The first camera in the array (if existing) is the default camera view into the scene.
    public lazy var cameras: [AiCamera] = UnsafeBufferPointer(start: scene.mCameras, count: numCameras).compactMap { AiCamera($0?.pointee) }
}

extension AiScene {
    @inlinable
    public func meshes(for node: AiNode) -> [AiMesh] {
        node.meshes.map { meshes[$0] }
    }
}
