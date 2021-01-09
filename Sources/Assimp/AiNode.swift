//
//  AiNode.swift
//
//
//  Created by Christian Treffs on 04.07.19.
//

import CAssimp

public struct AiNode {
    let node: aiNode

    init(_ aiNode: aiNode) {
        node = aiNode
    }

    /// The name of the node.
    ///
    /// The name might be empty (length of zero) but all nodes which need to be referenced by either bones or animations are named.
    /// Multiple nodes may have the same name, except for nodes which are referenced by bones (see #aiBone and #aiMesh::mBones).
    /// Their names *must* be unique.
    ///
    /// Cameras and lights reference a specific node by name - if there are multiple nodes with this name, they are assigned to each of them.
    /// There are no limitations with regard to the characters contained in the name string as it is usually taken directly from the source file.
    ///
    /// Implementations should be able to handle tokens such as whitespace, tabs, line feeds, quotation marks, ampersands etc.
    ///
    /// Sometimes assimp introduces new nodes not present in the source file into the hierarchy (usually out of necessity because sometimes the source hierarchy format is simply not compatible).
    ///
    /// Their names are surrounded by
    /// `<>`
    /// e.g.
    /// `<DummyRootNode>`
    public var name: String {
        String(aiString: node.mName) ?? ""
    }

    /// The transformation relative to the node's parent.
    public var transformation: aiMatrix4x4 {
        node.mTransformation
    }

    /// Parent node.
    ///
    /// NULL if this node is the root node.
    public var parent: AiNode? {
        guard let parent = node.mParent?.pointee else {
            return nil
        }
        return AiNode(parent)
    }

    /// The number of meshes of this node.
    public var numMeshes: Int {
        Int(node.mNumMeshes)
    }

    /// The number of child nodes of this node.
    public var numChildren: Int {
        Int(node.mNumChildren)
    }

    /// The meshes of this node.
    /// Each entry is an index into the mesh list of the #aiScene.
    public var meshes: [Int] {
        guard numMeshes > 0 else {
            return []
        }

        return(0..<numMeshes)
            .compactMap { node.mMeshes[$0] }
            .map { Int($0) }
    }

    /// The child nodes of this node.
    ///
    /// NULL if mNumChildren is 0.
    public var children: [AiNode] {
        guard numChildren > 0 else {
            return []
        }

        return (0..<numChildren)
            .compactMap { node.mChildren[$0] }
            .map { AiNode($0.pointee) }
    }

    /// Metadata associated with this node or NULL if there is no metadata.
    /// Whether any metadata is generated depends on the source file format.
    public var metaData: aiMetadata? {
        guard let meta = node.mMetaData?.pointee else {
            return nil
        }

        return meta
    }
}

extension AiNode: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        <AiNode '\(name)' meshes:\(meshes) children:\(numChildren)>\n\(children.map { "\t" + $0.debugDescription }.joined())
        """
    }
}
