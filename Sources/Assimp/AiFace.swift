//
//  AiFace.swift
//  
//
//  Created by Christian Treffs on 02.07.19.
//

import CAssimp

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
        guard numIndices > 0, let ptr = _face.mIndices else {
            return []
        }
        return [UInt32](UnsafeBufferPointer<UInt32>(start: ptr,
                                                    count: numIndices))
    }
}
