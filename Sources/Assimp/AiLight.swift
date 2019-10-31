//
//  AiLight.swift
//
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiLight {
    let light: aiLight

    init(_ aiLight: aiLight) {
        light = aiLight
    }

    public var name: String? {
        return String(aiString: light.mName)
    }
}
