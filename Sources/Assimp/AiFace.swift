//
//  AiFace.swift
//
//
//  Created by Christian Treffs on 02.07.19.
//

import CAssimp

/// The default face winding order is counter clockwise (CCW).
public struct AiFace {
    let face: aiFace

    init(_ aiFace: aiFace) {
        face = aiFace
    }

    /// Number of indices defining this face.
    ///
    /// The maximum value for this member is #AI_MAX_FACE_INDICES.
    public var numIndices: Int {
        return Int(face.mNumIndices)
    }

    /// Pointer to the indices array.
    /// Size of the array is given in numIndices.
    public var indices: [UInt32] {
        guard numIndices > 0 else {
            return []
        }

        let indices = [UInt32]((0..<numIndices).compactMap { face.mIndices[$0] })

        assert(indices.count == numIndices)

        return indices
    }
}

extension AiFace: Equatable {
    public static func == (lhs: AiFace, rhs: AiFace) -> Bool {
        return lhs.indices == rhs.indices &&
            lhs.numIndices == rhs.numIndices
    }
}

extension AiFace: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(indices)
        hasher.combine(numIndices)
    }
}
