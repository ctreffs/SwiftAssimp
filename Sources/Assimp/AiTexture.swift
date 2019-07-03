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

    var width: Int {
        return Int(_texture.mWidth)
    }

    var height: Int {
        return Int(_texture.mHeight)
    }

    var pcData: [aiTexel] {
        return [aiTexel](UnsafeMutableBufferPointer<aiTexel>(start: _texture.pcData,
                                                             count: width * height))

    }

}

public struct AiTextureType: RawRepresentable, Equatable, CustomDebugStringConvertible {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    public static let none = AiTextureType(rawValue: aiTextureType_NONE.rawValue)
    public static let diffuse = AiTextureType(rawValue: aiTextureType_DIFFUSE.rawValue)
    public static let specular = AiTextureType(rawValue: aiTextureType_SPECULAR.rawValue)
    public static let ambient = AiTextureType(rawValue: aiTextureType_AMBIENT.rawValue)
    public static let emissive = AiTextureType(rawValue: aiTextureType_EMISSIVE.rawValue)
    public static let height = AiTextureType(rawValue: aiTextureType_HEIGHT.rawValue)
    public static let normals = AiTextureType(rawValue: aiTextureType_NORMALS.rawValue)
    public static let shininess = AiTextureType(rawValue: aiTextureType_SHININESS.rawValue)
    public static let opacity = AiTextureType(rawValue: aiTextureType_OPACITY.rawValue)
    public static let displacement = AiTextureType(rawValue: aiTextureType_DISPLACEMENT.rawValue)
    public static let lightmap = AiTextureType(rawValue: aiTextureType_LIGHTMAP.rawValue)
    public static let reflection = AiTextureType(rawValue: aiTextureType_REFLECTION.rawValue)
    public static let unknown = AiTextureType(rawValue: aiTextureType_UNKNOWN.rawValue)

    @inlinable public var debugDescription: String {
        switch self {
        case .none:
            return "none"
        case .diffuse:
            return "diffuse"
        case .specular:
            return "specular"
        case .ambient:
            return "ambient"
        case .emissive:
            return "emissive"
        case .height:
            return "height"
        case .normals:
            return "normals"
        case .shininess:
            return "shininess"
        case .opacity:
            return "opacity"
        case .displacement:
            return "displacement"
        case .lightmap:
            return "lightmap"
        case .reflection:
            return "reflection"
        case .unknown:
            return "unknown"
        default:
            return "unexpected:\(rawValue)"
        }
    }
}
