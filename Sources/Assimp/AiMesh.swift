//
//  AiMesh.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp
import FirebladeMath

public struct AiMesh {

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

    let _mesh: aiMesh

    public init(_ aiMesh: aiMesh) {
        _mesh = aiMesh

    }

    /// Bitwise combination of the members of the #aiPrimitiveType enum.
    /// This specifies which types of primitives are present in the mesh.
    ///
    /// The "SortByPrimitiveType"-Step can be used to make sure the output meshes consist of one primitive type each.
    public var primitiveTypes: PrimitiveType {
        return PrimitiveType(rawValue: _mesh.mPrimitiveTypes)
    }

    /// The number of vertices in this mesh. This is also the size of all of the per-vertex data arrays.
    /// The maximum value for this member is #AI_MAX_VERTICES.
    public var numVertices: Int {
        return Int(_mesh.mNumVertices)
    }

    /// The number of primitives (triangles, polygons, lines) in this mesh.
    /// This is also the size of the mFaces array.
    /// The maximum value for this member is #AI_MAX_FACES.
    public var numFaces: Int {
        return Int(_mesh.mNumFaces)
    }

    /// Vertex positions. This array is always present in a mesh.
    /// The array is mNumVertices in size.
    public var vertices: [Vec3f] {
        guard numVertices > 0, let ptr = _mesh.mVertices else {
            return []
        }
        return [aiVector3D](UnsafeMutableBufferPointer<aiVector3D>(start: ptr,
                                                                   count: numVertices)).map { $0.vector }

    }

    /// Vertex normals.
    /// The array contains normalized vectors, NULL if not present.
    /// The array is mNumVertices in size.
    ///
    /// Normals are undefined for point and line primitives.
    /// A mesh consisting of points and lines only may not have normal vectors.
    /// Meshes with mixed primitive types (i.e. lines and triangles) may have normals,
    /// but the normals for vertices that are only referenced by point or line primitives
    /// are undefined and set to QNaN (WARN: qNaN compares to inequal to *everything*, even to qNaN itself.
    public var normals: [Vec3f] {
        guard let ptr = _mesh.mNormals else {
            return []
        }
        return [aiVector3D](UnsafeMutableBufferPointer<aiVector3D>(start: ptr,
                                                                   count: numVertices)).map { $0.vector }

    }

    /// Vertex tangents.
    /// The tangent of a vertex points in the direction of the positive X texture axis.
    /// The array contains normalized vectors, NULL if not present.
    /// The array is mNumVertices in size.
    ///
    /// A mesh consisting of points and lines only may not have normal vectors.
    /// Meshes with mixed primitive types (i.e. lines and triangles) may have normals,
    /// but the normals for vertices that are only referenced by point or line primitives
    /// are undefined and set to qNaN.
    /// See the #mNormals member for a detailed discussion of qNaNs.
    public var tangents: [Vec3f] {
        guard let ptr = _mesh.mTangents else {
            return []
        }
        return [aiVector3D](UnsafeMutableBufferPointer<aiVector3D>(start: ptr,
                                                                   count: numVertices)).map { $0.vector }

    }

    /// Vertex bitangents.
    /// The bitangent of a vertex points in the direction of the positive Y texture axis.
    /// The array contains normalized vectors, NULL if not present.
    /// The array is mNumVertices in size.
    public var bitangents: [Vec3f] {
        guard let ptr = _mesh.mBitangents else {
            return []
        }

        return [aiVector3D](UnsafeMutableBufferPointer<aiVector3D>(start: ptr,
                                                                   count: numVertices)).map { $0.vector }

    }

    /// Vertex color sets.
    ///
    /// A mesh may contain 0 to #AI_MAX_NUMBER_OF_COLOR_SETS vertex colors per vertex.
    /// NULL if not present.
    /// Each array is mNumVertices in size if present.
    public var colors: [[aiColor4D]] {
        let sets = [UnsafeMutablePointer<aiColor4D>?](withUnsafeBytes(of: _mesh.mColors) { ptr in ptr.bindMemory(to: UnsafeMutablePointer<aiColor4D>?.self) })

        let colors: [[aiColor4D]] = sets.compactMap { (optPtr: UnsafeMutablePointer<aiColor4D>?) -> [aiColor4D]? in
            guard let ptr = optPtr else {
                return nil
            }

            return [aiColor4D](UnsafeBufferPointer<aiColor4D>(start: ptr, count: numVertices))
        }
        return colors
    }

    /// Vertex texture coords, also known as UV channels.
    ///
    /// A mesh may contain 0 to AI_MAX_NUMBER_OF_TEXTURECOORDS per vertex.
    /// NULL if not present.
    /// The array is mNumVertices in size.
    public var textureCoords: [[Vec3f]] {
        let channels = [UnsafeMutablePointer<aiVector3D>?](withUnsafeBytes(of: _mesh.mTextureCoords) { ptr in ptr.bindMemory(to: UnsafeMutablePointer<aiVector3D>?.self) })

        let coords: [[Vec3f]] = channels.compactMap { (optPtr: UnsafeMutablePointer<aiVector3D>?) -> [Vec3f]? in
            guard let ptr = optPtr else {
                return nil
            }

            return [aiVector3D](UnsafeBufferPointer<aiVector3D>(start: ptr, count: numVertices)).map { $0.vector }
        }

        return coords
    }

    /// Specifies the number of components for a given UV channel.
    /// Up to three channels are supported (UVW, for accessing volume or cube maps).
    ///
    /// If the value is 2 for a given channel n, the component p.z of mTextureCoords[n][p] is set to 0.0f.
    /// If the value is 1 for a given channel, p.y is set to 0.0f, too.
    /// 4D coords are not supported
    public var numUVComponents: [Int] {
        return [UInt32](withUnsafeBytes(of: _mesh.mNumUVComponents) { ptr in ptr.bindMemory(to: UInt32.self) }).map { Int($0) }.filter { $0 > 0 }
    }

    /// The faces the mesh is constructed from.
    /// Each face refers to a number of vertices by their indices.
    /// This array is always present in a mesh, its size is given in mNumFaces.
    ///
    /// If the #AI_SCENE_FLAGS_NON_VERBOSE_FORMAT is NOT set each face references an unique set of vertices.
    public var faces: [AiFace] {
        guard numFaces > 0, let ptr = _mesh.mFaces else {
            return []
        }
        return [aiFace](UnsafeMutableBufferPointer<aiFace>(start: ptr,
                                                           count: numFaces)).map { AiFace($0) }

    }

    /// The number of bones this mesh contains.
    /// Can be 0, in which case the mBones array is NULL.
    public var numBones: Int {
        return Int(_mesh.mNumBones)
    }

    /// The material used by this mesh.
    ///
    /// A mesh uses only a single material.
    /// If an imported model uses multiple materials, the import splits up the mesh.
    /// Use this value as index into the scene's material list.
    public var materialIndex: Int {
        return Int(_mesh.mMaterialIndex)
    }

    /// Name of the mesh. Meshes can be named, but this is not a requirement and leaving this field empty is totally fine.
    ///
    /// There are mainly three uses for mesh names:
    ///    - some formats name nodes and meshes independently.
    ///    - importers tend to split meshes up to meet the one-material-per-mesh requirement.
    ///      Assigning the same (dummy) name to each of the result meshes aids the caller at recovering the original mesh partitioning.
    ///    - Vertex animations refer to meshes by their names.
    ///
    public var name: String {
        return String(aiString: _mesh.mName) ?? ""
    }

    /// The number of attachment meshes.
    ///
    /// **Note:** Currently only works with Collada loader.
    public var numAnimMeshes: Int {
        return Int(_mesh.mNumAnimMeshes)
    }

    /// Method of morphing when animeshes are specified.
    public var method: UInt32 {
        return _mesh.mMethod
    }

}
