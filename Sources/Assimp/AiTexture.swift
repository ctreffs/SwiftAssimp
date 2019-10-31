//
//  AiTexture.swift
//
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiTexture {
    let texture: aiTexture

    public init(_ aiTexture: aiTexture) {
        texture = aiTexture
    }

    var width: Int {
        return Int(texture.mWidth)
    }

    var height: Int {
        return Int(texture.mHeight)
    }

    var pcData: [aiTexel] {
        return [aiTexel](UnsafeMutableBufferPointer<aiTexel>(start: texture.pcData,
                                                             count: width * height))
    }
}

public struct AiTextureType: RawRepresentable, Equatable, CustomDebugStringConvertible {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    /// Dummy value.
    ///
    /// No texture, but the value to be used as 'texture semantic' (#aiMaterialProperty::mSemantic)
    /// for all material properties *not* related to textures.
    public static let none = AiTextureType(rawValue: aiTextureType_NONE.rawValue)

    /// The texture is combined with the result of the diffuse lighting equation.
    public static let diffuse = AiTextureType(rawValue: aiTextureType_DIFFUSE.rawValue)

    /// The texture is combined with the result of the specular lighting equation.
    public static let specular = AiTextureType(rawValue: aiTextureType_SPECULAR.rawValue)

    /// The texture is combined with the result of the ambient lighting equation.
    public static let ambient = AiTextureType(rawValue: aiTextureType_AMBIENT.rawValue)

    /// The texture is added to the result of the lighting calculation.
    /// It isn't influenced by incoming light.
    public static let emissive = AiTextureType(rawValue: aiTextureType_EMISSIVE.rawValue)

    /// The texture is a height map.
    ///
    /// By convention, higher gray-scale values stand for higher elevations from the base height.
    public static let height = AiTextureType(rawValue: aiTextureType_HEIGHT.rawValue)

    /// The texture is a (tangent space) normal-map.
    ///
    /// Again, there are several conventions for tangent-space normal maps.
    /// Assimp does (intentionally) not distinguish here.
    public static let normals = AiTextureType(rawValue: aiTextureType_NORMALS.rawValue)

    /// The texture defines the glossiness of the material.
    ///
    /// The glossiness is in fact the exponent of the specular (phong) lighting equation.
    /// Usually there is a conversion function defined to map the linear color values in the texture to a suitable exponent.
    /// Have fun.
    public static let shininess = AiTextureType(rawValue: aiTextureType_SHININESS.rawValue)

    /// The texture defines per-pixel opacity.
    ///
    /// Usually 'white' means opaque and 'black' means 'transparency'.
    /// Or quite the opposite.
    /// Have fun.
    public static let opacity = AiTextureType(rawValue: aiTextureType_OPACITY.rawValue)

    /// Displacement texture
    ///
    /// The exact purpose and format is application-dependent.
    /// Higher color values stand for higher vertex displacements.
    public static let displacement = AiTextureType(rawValue: aiTextureType_DISPLACEMENT.rawValue)

    /// Lightmap texture (aka Ambient Occlusion)
    ///
    /// Both 'Lightmaps' and dedicated 'ambient occlusion maps' are covered by this material property.
    /// The texture contains a scaling value for the final color value of a pixel.
    /// Its intensity is not affected by incoming light.
    public static let lightmap = AiTextureType(rawValue: aiTextureType_LIGHTMAP.rawValue)

    /// Reflection texture
    ///
    /// Contains the color of a perfect mirror reflection.
    /// Rarely used, almost never for real-time applications.
    public static let reflection = AiTextureType(rawValue: aiTextureType_REFLECTION.rawValue)

    /// Unknown texture
    ///
    /// A texture reference that does not match any of the definitions above is considered to be 'unknown'.
    /// It is still imported, but is excluded from any further postprocessing.
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
