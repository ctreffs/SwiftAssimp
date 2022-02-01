//
// AiFace.swift
// SwiftAssimp
//
// Copyright © 2019-2022 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

/// The default face winding order is counter clockwise (CCW).
public struct AiFace {
    let face: aiFace

    init(_ aiFace: aiFace) {
        face = aiFace
    }

    /// Number of indices defining this face.
    ///
    /// The maximum value for this member is #AI_MAX_FACE_INDICES.
    public lazy var numIndices: Int = .init(face.mNumIndices)

    /// Pointer to the indices array.
    /// Size of the array is given in numIndices.
    public lazy var indices: [UInt32] = Array(UnsafeBufferPointer(start: face.mIndices, count: numIndices))
}
