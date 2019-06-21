//
//  AiTexture.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiTexture {
    fileprivate let _texture: aiTexture

    public init(_ aiTexture: aiTexture) {
        _texture = aiTexture
    }

    var width: Int { return Int(_texture.mWidth) }
    var height: Int { return Int(_texture.mHeight) }

}
