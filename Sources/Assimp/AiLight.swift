//
//  AiLight.swift
//
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiLight {
    private let _light: aiLight

    init(_ aiLight: aiLight) {
        _light = aiLight
    }

    public var name: String? {
        return String(aiString: _light.mName)
    }
}
