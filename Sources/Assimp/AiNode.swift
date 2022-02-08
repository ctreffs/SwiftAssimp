//
// AiNode.swift
// SwiftAssimp
//
// Copyright © 2019-2022 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

public struct AiNode {
    let node: aiNode

    init(_ node: aiNode) {
        self.node = node
        name = String(node.mName)
        transformation = AiMatrix4x4(node.mTransformation)
        let numMeshes = Int(node.mNumMeshes)
        self.numMeshes = numMeshes
        let numChildren = Int(node.mNumChildren)
        self.numChildren = numChildren
        meshes = {
            guard numMeshes > 0 else {
                return []
            }

            return (0 ..< numMeshes)
                .compactMap { node.mMeshes[$0] }
                .map { Int($0) }
        }()

        if numChildren > 0 {
            children = UnsafeBufferPointer(start: node.mChildren, count: numChildren).compactMap { AiNode($0?.pointee) }
        } else {
            children = []
        }

        if let meta = node.mMetaData {
            metaData = AiMetadata(meta.pointee)
        } else {
            metaData = nil
        }
    }

    init?(_ node: aiNode?) {
        guard let node = node else {
            return nil
        }
        self.init(node)
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
    public var name: String?

    /// The transformation relative to the node's parent.
    public var transformation: AiMatrix4x4

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
    public var numMeshes: Int

    /// The number of child nodes of this node.
    public var numChildren: Int

    /// The meshes of this node.
    /// Each entry is an index into the mesh list of the #aiScene.
    public var meshes: [Int]

    /// The child nodes of this node.
    ///
    /// NULL if mNumChildren is 0.
    public var children: [AiNode]

    /// Metadata associated with this node or NULL if there is no metadata.
    /// Whether any metadata is generated depends on the source file format.
    public var metaData: AiMetadata?
}

extension AiNode: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        <AiNode '\(name ?? "")' meshes:\(meshes) children:\(numChildren)>\n\(children.map { "\t" + $0.debugDescription }.joined())
        """
    }
}

/// Container for holding metadata.
/// Metadata is a key-value store using string keys and values.
public struct AiMetadata {
    init(_ meta: aiMetadata) {
        numProperties = Int(meta.mNumProperties)
        keys = UnsafeBufferPointer(start: meta.mKeys, count: numProperties).compactMap(String.init)
        values = UnsafeBufferPointer(start: meta.mValues, count: numProperties).compactMap(Entry.init)
    }

    /// Length of the mKeys and mValues arrays, respectively
    public var numProperties: Int

    /// Arrays of keys, may not be NULL.
    /// Entries in this array may not be NULL as well.
    public var keys: [String]

    /// Arrays of values, may not be NULL.
    /// Entries in this array may be NULL if the corresponding property key has no assigned value.
    public var values: [Entry]

    public var metadata: [String: Entry] {
        [String: Entry](uniqueKeysWithValues: (0 ..< numProperties).map { (keys[$0], values[$0]) })
    }

    public enum Entry {
        case bool(Bool)
        case int32(Int32)
        case uint64(UInt64)
        case float(Float)
        case double(Double)
        case string(String)
        case vec3(Vec3)
        case metadata(AiMetadata)

        init?(_ entry: aiMetadataEntry) {
            guard let pData = entry.mData else {
                return nil
            }

            switch entry.mType {
            case AI_BOOL:
                self = .bool(pData.bindMemory(to: Bool.self, capacity: 1).pointee)

            case AI_INT32:
                self = .int32(pData.bindMemory(to: Int32.self, capacity: 1).pointee)

            case AI_UINT64:
                self = .uint64(pData.bindMemory(to: UInt64.self, capacity: 1).pointee)

            case AI_FLOAT:
                self = .float(pData.bindMemory(to: Float.self, capacity: 1).pointee)

            case AI_DOUBLE:
                self = .double(pData.bindMemory(to: Double.self, capacity: 1).pointee)

            case AI_AISTRING:
                guard let string = String(pData.bindMemory(to: aiString.self, capacity: 1).pointee) else {
                    return nil
                }
                self = .string(string)

            case AI_AIVECTOR3D:
                self = .vec3(Vec3(pData.bindMemory(to: aiVector3D.self, capacity: 1).pointee))

            case AI_AIMETADATA:
                self = .metadata(AiMetadata(pData.bindMemory(to: aiMetadata.self, capacity: 1).pointee))

            case AI_META_MAX:
                return nil

            case FORCE_32BIT:
                return nil

            default:
                return nil
            }
        }
    }
}
