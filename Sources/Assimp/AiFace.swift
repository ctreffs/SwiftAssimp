//
// AiFace.swift
// SwiftAssimp
//
// Copyright © 2019-2022 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

/// The default face winding order is counter clockwise (CCW).
public struct AiFace {
    init(_ face: aiFace) {
        numIndices = Int(face.mNumIndices)
        indices = Array(UnsafeBufferPointer(start: face.mIndices, count: numIndices))
    }

    /// Number of indices defining this face.
    ///
    /// The maximum value for this member is #AI_MAX_FACE_INDICES.
    public var numIndices: Int

    /// Pointer to the indices array.
    /// Size of the array is given in numIndices.
    public var indices: [UInt32]
}
