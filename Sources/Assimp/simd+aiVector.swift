//
//  simd+aiVector.swift
//
//
//  Created by Christian Treffs on 01.07.19.
//

import CAssimp

extension aiVector3D {
    @inlinable public var vector: SIMD3<Float> {
        return SIMD3<Float>(x, y, z)
    }
}

extension aiVector2D {
    @inlinable public var vector: SIMD2<Float> {
        return SIMD2<Float>(x, y)
    }
}

extension SIMD3 where Scalar == Float {
    public init(_ aiVector3D: aiVector3D) {
        self.init(aiVector3D.x, aiVector3D.y, aiVector3D.z)
    }
}

extension SIMD2 where Scalar == Float {
    public init(_ aiVector2D: aiVector2D) {
        self.init(aiVector2D.x, aiVector2D.y)
    }
}
