//
// AiAnimation.swift
// SwiftAssimp
//
// Copyright © 2019-2022 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

/// An animation consists of key-frame data for a number of nodes.
/// For each node affected by the animation a separate series of data is given
public struct AiAnimation {
    let animation: aiAnimation

    init(_ animation: aiAnimation) {
        self.animation = animation
    }

    init?(_ animation: aiAnimation?) {
        guard let animation = animation else {
            return nil
        }
        self.init(animation)
    }

    /** The name of the animation. If the modeling package this data was
     *  exported from does support only a single animation channel, this
     *  name is usually empty (length is zero). */
    public lazy var name: String? = String(animation.mName)

    /** Duration of the animation in ticks.  */
    public lazy var duration: Double = animation.mDuration

    /** Ticks per second. 0 if not specified in the imported file */
    public lazy var ticksPerSecond: Double = animation.mTicksPerSecond

    /** The number of bone animation channels. Each channel affects
     *  a single node. */
    public lazy var numChannels = Int(animation.mNumChannels)

    /** The node animation channels. Each channel affects a single node.
     *  The array is mNumChannels in size. */
    public lazy var channels: [AiNodeAnim] = UnsafeBufferPointer(start: animation.mChannels, count: numChannels).compactMap { AiNodeAnim($0?.pointee) }

    /** The number of mesh animation channels. Each channel affects
     *  a single mesh and defines vertex-based animation. */
    public lazy var numMeshChannels: Int = .init(animation.mNumMeshChannels)

    /** The mesh animation channels. Each channel affects a single mesh.
     *  The array is mNumMeshChannels in size. */
    public lazy var meshChannels: [AiMeshAnim] = UnsafeBufferPointer(start: animation.mMeshChannels, count: numMeshChannels).compactMap { AiMeshAnim($0?.pointee) }

    /** The number of mesh animation channels. Each channel affects
     *  a single mesh and defines morphing animation. */
    public lazy var mNumMorphMeshChannels = Int(animation.mNumMorphMeshChannels)

    /** The morph mesh animation channels. Each channel affects a single mesh.
     *  The array is mNumMorphMeshChannels in size. */
    public lazy var morphMeshChannels: [AiMeshMorphAnim] = UnsafeBufferPointer(start: animation.mMorphMeshChannels, count: mNumMorphMeshChannels).compactMap { AiMeshMorphAnim($0?.pointee) }
}

/// Describes the animation of a single node.
///
/// The name specifies the bone/node which is affected by this animation channel.
/// The keyframes are given in three separate series of values, one each for position, rotation and scaling.
/// The transformation matrix computed from these values replaces the node's original transformation matrix at a specific time.
/// This means all keys are absolute and not relative to the bone default pose.
/// The order in which the transformations are applied is - as usual - scaling, rotation, translation.
///
/// All keys are returned in their correct, chronological order.
/// Duplicate keys don't pass the validation step.
/// Most likely there will be no negative time values, but they are not forbidden also ( so implementations need to cope with them! )
public struct AiNodeAnim {
    let anim: aiNodeAnim

    init?(_ anim: aiNodeAnim?) {
        guard let anim = anim else {
            return nil
        }

        self.anim = anim
    }
}

/// Describes vertex-based animations for a single mesh or a group of meshes.
/// Meshes carry the animation data for each frame in their aiMesh::mAnimMeshes array.
/// The purpose of aiMeshAnim is to define keyframes linking each mesh attachment to a particular point in time.
public struct AiMeshAnim {
    let anim: aiMeshAnim

    init?(_ anim: aiMeshAnim?) {
        guard let anim = anim else {
            return nil
        }

        self.anim = anim
    }
}

/// Describes a morphing animation of a given mesh.
public struct AiMeshMorphAnim {
    let anim: aiMeshMorphAnim

    init?(_ anim: aiMeshMorphAnim?) {
        guard let anim = anim else {
            return nil
        }
        self.anim = anim
    }
}
