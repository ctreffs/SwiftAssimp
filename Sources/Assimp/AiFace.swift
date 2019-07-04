//
//  AiFace.swift
//  
//
//  Created by Christian Treffs on 02.07.19.
//

import CAssimp

/// The default face winding order is counter clockwise (CCW).
public struct AiFace {

    let _face: aiFace

    init(_ aiFace: aiFace) {
        _face = aiFace
    }

    /// Number of indices defining this face.
    ///
    /// The maximum value for this member is #AI_MAX_FACE_INDICES.
    public var numIndices: Int {
        return Int(_face.mNumIndices)
    }

    /// Pointer to the indices array.
    /// Size of the array is given in numIndices.
    public var indices: [UInt32] {
        guard numIndices > 0 else {
            return []
        }

        let _indices = (0..<numIndices)
            .compactMap { _face.mIndices[$0] }
            .map { $0 }

        assert(_indices.count == numIndices)

        return _indices
    }
}
