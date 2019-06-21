//
//  AiMaterial.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiMaterial {
    private let _material: aiMaterial

    init(_ aiMaterial: aiMaterial) {
        self._material = aiMaterial
    }

    public var numProperties: Int {
        return Int(_material.mNumProperties)
    }

    public var properties: [aiMaterialProperty] {
        [aiMaterialProperty](UnsafeMutableBufferPointer<aiMaterialProperty>(start: _material.mProperties?.pointee,
                                                                            count: numProperties))

    }
}
