//
// AiMesh.swift
// SwiftAssimp
//
// Copyright © 2019-2022 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

public final class AiMesh {
    public struct PrimitiveType: OptionSet {
        public let rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let point = PrimitiveType(rawValue: aiPrimitiveType_POINT.rawValue)
        public static let line = PrimitiveType(rawValue: aiPrimitiveType_LINE.rawValue)
        public static let triangle = PrimitiveType(rawValue: aiPrimitiveType_TRIANGLE.rawValue)
        public static let polygon = PrimitiveType(rawValue: aiPrimitiveType_POLYGON.rawValue)
    }

    let mesh: aiMesh

    init(_ mesh: aiMesh) {
        self.mesh = mesh
        primitiveTypes = PrimitiveType(rawValue: mesh.mPrimitiveTypes)
        numVertices = Int(mesh.mNumVertices)
        numFaces = Int(mesh.mNumFaces)
        numBones = Int(mesh.mNumBones)
        materialIndex = Int(mesh.mMaterialIndex)
        name = String(mesh.mName)
        numAnimMeshes = Int(mesh.mNumAnimMeshes)
        method = mesh.mMethod
    }

    convenience init?(_ mesh: aiMesh?) {
        guard let mesh = mesh else {
            return nil
        }

        self.init(mesh)
    }

    /// Bitwise combination of the members of the #aiPrimitiveType enum.
    /// This specifies which types of primitives are present in the mesh.
    ///
    /// The "SortByPrimitiveType"-Step can be used to make sure the output meshes consist of one primitive type each.
    public var primitiveTypes: PrimitiveType

    /// The number of vertices in this mesh. This is also the size of all of the per-vertex data arrays.
    /// The maximum value for this member is #AI_MAX_VERTICES.
    public var numVertices: Int

    /// The number of primitives (triangles, polygons, lines) in this mesh.
    /// This is also the size of the mFaces array.
    /// The maximum value for this member is #AI_MAX_FACES.
    public var numFaces: Int

    /// Vertex positions. This array is always present in a mesh.
    /// The array is numVertices * 3 in size.
    public lazy var vertices = withUnsafeVertices([AiReal].init)

    public func withUnsafeVertices<R>(_ body: (UnsafeBufferPointer<AiReal>) throws -> R) rethrows -> R {
        let count = numVertices * 3
        return try mesh.mVertices.withMemoryRebound(to: AiReal.self, capacity: count) {
            try body(UnsafeBufferPointer(start: $0, count: count))
        }
    }

    /// Vertex normals.
    /// The array contains normalized vectors, NULL if not present.
    /// The array is mNumVertices * 3 in size.
    ///
    /// Normals are undefined for point and line primitives.
    /// A mesh consisting of points and lines only may not have normal vectors.
    /// Meshes with mixed primitive types (i.e. lines and triangles) may have normals,
    /// but the normals for vertices that are only referenced by point or line primitives
    /// are undefined and set to QNaN (WARN: qNaN compares to inequal to *everything*, even to qNaN itself.
    public lazy var normals = withUnsafeNormals([AiReal].init)

    public func withUnsafeNormals<R>(_ body: (UnsafeBufferPointer<AiReal>) throws -> R) rethrows -> R {
        let count = numVertices * 3
        return try mesh.mNormals.withMemoryRebound(to: AiReal.self, capacity: count) {
            try body(UnsafeBufferPointer(start: $0, count: count))
        }
    }

    /// Vertex tangents.
    /// The tangent of a vertex points in the direction of the positive X texture axis.
    /// The array contains normalized vectors, NULL if not present.
    /// The array is mNumVertices * 3 in size.
    ///
    /// A mesh consisting of points and lines only may not have normal vectors.
    /// Meshes with mixed primitive types (i.e. lines and triangles) may have normals,
    /// but the normals for vertices that are only referenced by point or line primitives
    /// are undefined and set to qNaN.
    /// See the #mNormals member for a detailed discussion of qNaNs.
    public lazy var tangents = withUnsafeTangents([AiReal].init)

    public func withUnsafeTangents<R>(_ body: (UnsafeBufferPointer<AiReal>) throws -> R) rethrows -> R {
        let count = numVertices * 3
        return try mesh.mTangents.withMemoryRebound(to: AiReal.self, capacity: count) {
            try body(UnsafeBufferPointer(start: $0, count: count))
        }
    }

    /// Vertex bitangents.
    /// The bitangent of a vertex points in the direction of the positive Y texture axis.
    /// The array contains normalized vectors, NULL if not present.
    /// The array is mNumVertices * 3 in size.
    public lazy var bitangents = withUnsafeBitangents([AiReal].init)

    public func withUnsafeBitangents<R>(_ body: (UnsafeBufferPointer<AiReal>) throws -> R) rethrows -> R {
        let count = numVertices * 3
        return try mesh.mBitangents.withMemoryRebound(to: AiReal.self, capacity: count) {
            try body(UnsafeBufferPointer(start: $0, count: count))
        }
    }

    public typealias Channels<T> = (T, T, T, T, T, T, T, T)

    /// Vertex color sets.
    ///
    /// A mesh may contain 0 to #AI_MAX_NUMBER_OF_COLOR_SETS vertex colors per vertex.
    /// NULL if not present.
    /// Each array is numVertices * 4 in size if present.
    /// Returns RGBA colors.
    public lazy var colors: Channels<[AiReal]?> = {
        typealias CVertexColorSet = (UnsafeMutablePointer<aiColor4D>?,
                                     UnsafeMutablePointer<aiColor4D>?,
                                     UnsafeMutablePointer<aiColor4D>?,
                                     UnsafeMutablePointer<aiColor4D>?,
                                     UnsafeMutablePointer<aiColor4D>?,
                                     UnsafeMutablePointer<aiColor4D>?,
                                     UnsafeMutablePointer<aiColor4D>?,
                                     UnsafeMutablePointer<aiColor4D>?)

        let maxColorsPerSet = numVertices * 4 // aiColor4D(RGBA) * numVertices
        func colorSet(at keyPath: KeyPath<CVertexColorSet, UnsafeMutablePointer<aiColor4D>?>) -> [AiReal]? {
            guard let baseAddress = mesh.mColors[keyPath: keyPath] else {
                return nil
            }

            return baseAddress.withMemoryRebound(to: AiReal.self, capacity: maxColorsPerSet) { pColorSet in
                [AiReal](UnsafeBufferPointer(start: pColorSet, count: maxColorsPerSet))
            }
        }

        return (
            colorSet(at: \.0),
            colorSet(at: \.1),
            colorSet(at: \.2),
            colorSet(at: \.3),
            colorSet(at: \.4),
            colorSet(at: \.5),
            colorSet(at: \.6),
            colorSet(at: \.7)
        )
    }()

    /// Vertex texture coords, also known as UV channels.
    ///
    /// A mesh may contain 0 to AI_MAX_NUMBER_OF_TEXTURECOORDS per vertex.
    /// NULL if not present.
    /// The array is numVertices * 3 in size.
    public lazy var texCoords: Channels<[AiReal]?> = {
        typealias CVertexUVChannels = (UnsafeMutablePointer<aiVector3D>?,
                                       UnsafeMutablePointer<aiVector3D>?,
                                       UnsafeMutablePointer<aiVector3D>?,
                                       UnsafeMutablePointer<aiVector3D>?,
                                       UnsafeMutablePointer<aiVector3D>?,
                                       UnsafeMutablePointer<aiVector3D>?,
                                       UnsafeMutablePointer<aiVector3D>?,
                                       UnsafeMutablePointer<aiVector3D>?)

        let maxTexCoordsPerChannel = numVertices * 3 // aiVector3D * numVertices

        func uvChannel(at keyPath: KeyPath<CVertexUVChannels, UnsafeMutablePointer<aiVector3D>?>) -> [AiReal]? {
            guard let baseAddress = mesh.mTextureCoords[keyPath: keyPath] else {
                return nil
            }

            return baseAddress.withMemoryRebound(to: AiReal.self, capacity: maxTexCoordsPerChannel) {
                [AiReal](UnsafeBufferPointer(start: $0, count: maxTexCoordsPerChannel))
            }
        }

        return Channels(
            uvChannel(at: \.0),
            uvChannel(at: \.1),
            uvChannel(at: \.2),
            uvChannel(at: \.3),
            uvChannel(at: \.4),
            uvChannel(at: \.5),
            uvChannel(at: \.6),
            uvChannel(at: \.7)
        )
    }()

    public lazy var texCoordsPacked: Channels<[AiReal]?> = {
        func packChannel(uv: KeyPath<Channels<Int>, Int>, tex: KeyPath<Channels<[AiReal]?>, [AiReal]?>) -> [AiReal]? {
            let numComps: Int = numUVComponents[keyPath: uv]
            guard let uvs = self.texCoords[keyPath: tex] else {
                return nil
            }
            switch numComps {
            case 1: // u
                return stride(from: 0, to: uvs.count, by: 3).map { uvs[$0] }

            case 2: // uv
                return stride(from: 0, to: uvs.count, by: 3).flatMap { uvs[$0 ... $0 + 1] }

            case 3: // uvw
                return uvs

            default:
                return nil
            }
        }

        return Channels(
            packChannel(uv: \.0, tex: \.0),
            packChannel(uv: \.1, tex: \.1),
            packChannel(uv: \.2, tex: \.2),
            packChannel(uv: \.3, tex: \.3),
            packChannel(uv: \.4, tex: \.4),
            packChannel(uv: \.5, tex: \.5),
            packChannel(uv: \.6, tex: \.6),
            packChannel(uv: \.7, tex: \.7)
        )
    }()

    /// Specifies the number of components for a given UV channel.
    /// Up to three channels are supported (UVW, for accessing volume or cube maps).
    ///
    /// If the value is 2 for a given channel n, the component p.z of mTextureCoords[n][p] is set to 0.0f.
    /// If the value is 1 for a given channel, p.y is set to 0.0f, too.
    /// 4D coords are not supported
    public lazy var numUVComponents = Channels(Int(mesh.mNumUVComponents.0),
                                               Int(mesh.mNumUVComponents.1),
                                               Int(mesh.mNumUVComponents.2),
                                               Int(mesh.mNumUVComponents.3),
                                               Int(mesh.mNumUVComponents.4),
                                               Int(mesh.mNumUVComponents.5),
                                               Int(mesh.mNumUVComponents.6),
                                               Int(mesh.mNumUVComponents.7))

    /// The faces the mesh is constructed from.
    /// Each face refers to a number of vertices by their indices.
    /// This array is always present in a mesh, its size is given in mNumFaces.
    ///
    /// If the #AI_SCENE_FLAGS_NON_VERBOSE_FORMAT is NOT set each face references an unique set of vertices.
    public lazy var faces: [AiFace] = UnsafeBufferPointer(start: mesh.mFaces, count: numFaces).compactMap(AiFace.init)

    /// The number of bones this mesh contains.
    /// Can be 0, in which case the mBones array is NULL.
    public var numBones: Int

    /// The material used by this mesh.
    ///
    /// A mesh uses only a single material.
    /// If an imported model uses multiple materials, the import splits up the mesh.
    /// Use this value as index into the scene's material list.
    public var materialIndex: Int

    /// Name of the mesh. Meshes can be named, but this is not a requirement and leaving this field empty is totally fine.
    ///
    /// There are mainly three uses for mesh names:
    ///    - some formats name nodes and meshes independently.
    ///    - importers tend to split meshes up to meet the one-material-per-mesh requirement.
    ///      Assigning the same (dummy) name to each of the result meshes aids the caller at recovering the original mesh partitioning.
    ///    - Vertex animations refer to meshes by their names.
    ///
    public var name: String?

    /// The number of attachment meshes.
    ///
    /// **Note:** Currently only works with Collada loader.
    public var numAnimMeshes: Int

    /// Method of morphing when animeshes are specified.
    public var method: UInt32
}
