//
//  AiMesh.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiMesh {

    fileprivate let _mesh: aiMesh

    public init(_ aiMesh: aiMesh) {
        _mesh = aiMesh

    }

    public var name: String? {
        return String(aiString: _mesh.mName)
    }

    public var numVertices: Int {
        return Int(_mesh.mNumVertices)
    }

    public var vertices: [aiVector3D] {
        return [aiVector3D](UnsafeMutableBufferPointer<aiVector3D>(start: _mesh.mVertices,
                                                                   count: numVertices))

    }

    public var numFaces: Int {
        return Int(_mesh.mNumFaces)
    }

    public var faces: [aiFace] {
        return [aiFace](UnsafeMutableBufferPointer<aiFace>(start: _mesh.mFaces,
                                                           count: numFaces))

    }

    public var normals: [aiVector3D] {
        return [aiVector3D](UnsafeMutableBufferPointer<aiVector3D>(start: _mesh.mNormals,
                                                                   count: numVertices))

    }

    public var tangents: [aiVector3D] {
        return [aiVector3D](UnsafeMutableBufferPointer<aiVector3D>(start: _mesh.mTangents,
                                                                   count: numVertices))

    }

    public var bitangents: [aiVector3D] {
        return [aiVector3D](UnsafeMutableBufferPointer<aiVector3D>(start: _mesh.mBitangents,
                                                                   count: numVertices))

    }

    public var numBones: Int {
        return Int(_mesh.mNumBones)
    }

}
