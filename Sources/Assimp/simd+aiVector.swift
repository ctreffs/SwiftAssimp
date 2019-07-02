//
//  simd+aiVector.swift
//  
//
//  Created by Christian Treffs on 01.07.19.
//

import CAssimp
import FirebladeMath

public extension aiVector3D {
    @inlinable var vector: Vec3f {
        return Vec3f(x, y, z)
    }
}

public extension aiVector2D {
    @inlinable var vector: Vec2f {
        return Vec2f(x, y)
    }
}

public extension Vec3f {
    init(_ aiVector3D: aiVector3D) {
        self.init(aiVector3D.x, aiVector3D.y, aiVector3D.z)
    }
}

public extension Vec2f {
    init(_ aiVector2D: aiVector2D) {
        self.init(aiVector2D.x, aiVector2D.y)
    }
}
