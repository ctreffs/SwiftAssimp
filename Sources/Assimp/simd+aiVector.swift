//
//  simd+aiVector.swift
//
//
//  Created by Christian Treffs on 01.07.19.
//

@_implementationOnly import CAssimp

extension aiVector3D {
    @_transparent var vector: SIMD3<Float> {
        SIMD3<Float>(x, y, z)
    }
}

extension aiVector2D {
    @_transparent var vector: SIMD2<Float> {
        SIMD2<Float>(x, y)
    }
}

extension SIMD3 where Scalar == Float {
    @_transparent init(_ aiVector3D: aiVector3D) {
        self.init(aiVector3D.x, aiVector3D.y, aiVector3D.z)
    }

    @_transparent init(_ aiColor3D: aiColor3D) {
        self.init(aiColor3D.r, aiColor3D.g, aiColor3D.b)
    }
}

extension SIMD2 where Scalar == Float {
    @_transparent init(_ aiVector2D: aiVector2D) {
        self.init(aiVector2D.x, aiVector2D.y)
    }
}

public typealias Vec2 = SIMD2<Float>
public typealias Vec3 = SIMD3<Float>

public typealias AiReal = Float


public struct AiMatrix4x4 {
    public let a1: AiReal
    public let a2: AiReal
    public let a3: AiReal
    public let a4: AiReal
    public let b1: AiReal
    public let b2: AiReal
    public let b3: AiReal
    public let b4: AiReal
    public let c1: AiReal
    public let c2: AiReal
    public let c3: AiReal
    public let c4: AiReal
    public let d1: AiReal
    public let d2: AiReal
    public let d3: AiReal
    public let d4: AiReal

    init(_ m: aiMatrix4x4) {
        self.a1 = m.a1
        self.a2 = m.a2
        self.a3 = m.a3
        self.a4 = m.a4
        self.b1 = m.b1
        self.b2 = m.b2
        self.b3 = m.b3
        self.b4 = m.b4
        self.c1 = m.c1
        self.c2 = m.c2
        self.c3 = m.c3
        self.c4 = m.c4
        self.d1 = m.d1
        self.d2 = m.d2
        self.d3 = m.d3
        self.d4 = m.d4
    }
}
