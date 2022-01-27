//
//  File.swift
//  
//
//  Created by Christian Treffs on 27.01.22.
//

@_implementationOnly import CAssimp

public struct AiTextureType: RawRepresentable {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    init(_ textureType: aiTextureType) {
        self.init(rawValue: textureType.rawValue)
    }

    var type: aiTextureType { aiTextureType(rawValue: rawValue) }

    /// Dummy value.
    ///
    /// No texture, but the value to be used as 'texture semantic' (#aiMaterialProperty::mSemantic)
    /// for all material properties *not* related to textures.
    public static let none = AiTextureType(aiTextureType_NONE)

    /// The texture is combined with the result of the diffuse lighting equation.
    public static let diffuse = AiTextureType(aiTextureType_DIFFUSE)

    /// The texture is combined with the result of the specular lighting equation.
    public static let specular = AiTextureType(aiTextureType_SPECULAR)

    /// The texture is combined with the result of the ambient lighting equation.
    public static let ambient = AiTextureType(aiTextureType_AMBIENT)

    /// The texture is added to the result of the lighting calculation.
    /// It isn't influenced by incoming light.
    public static let emissive = AiTextureType(aiTextureType_EMISSIVE)

    /// The texture is a height map.
    ///
    /// By convention, higher gray-scale values stand for higher elevations from the base height.
    public static let height = AiTextureType(aiTextureType_HEIGHT)

    /// The texture is a (tangent space) normal-map.
    ///
    /// Again, there are several conventions for tangent-space normal maps.
    /// Assimp does (intentionally) not distinguish here.
    public static let normals = AiTextureType(aiTextureType_NORMALS)

    /// The texture defines the glossiness of the material.
    ///
    /// The glossiness is in fact the exponent of the specular (phong) lighting equation.
    /// Usually there is a conversion function defined to map the linear color values in the texture to a suitable exponent.
    /// Have fun.
    public static let shininess = AiTextureType(aiTextureType_SHININESS)

    /// The texture defines per-pixel opacity.
    ///
    /// Usually 'white' means opaque and 'black' means 'transparency'.
    /// Or quite the opposite.
    /// Have fun.
    public static let opacity = AiTextureType(aiTextureType_OPACITY)

    /// Displacement texture
    ///
    /// The exact purpose and format is application-dependent.
    /// Higher color values stand for higher vertex displacements.
    public static let displacement = AiTextureType(aiTextureType_DISPLACEMENT)

    /// Lightmap texture (aka Ambient Occlusion)
    ///
    /// Both 'Lightmaps' and dedicated 'ambient occlusion maps' are covered by this material property.
    /// The texture contains a scaling value for the final color value of a pixel.
    /// Its intensity is not affected by incoming light.
    public static let lightmap = AiTextureType(aiTextureType_LIGHTMAP)

    /// Reflection texture
    ///
    /// Contains the color of a perfect mirror reflection.
    /// Rarely used, almost never for real-time applications.
    public static let reflection = AiTextureType(aiTextureType_REFLECTION)

    /// PBR Materials
    ///
    /// PBR definitions from maya and other modelling packages now use this standard.
    /// This was originally introduced around 2012.
    /// Support for this is in game engines like Godot, Unreal or Unity3D.
    /// Modelling packages which use this are very common now.

    public static let baseColor = AiTextureType(aiTextureType_BASE_COLOR)

    public static let normalCamera = AiTextureType(aiTextureType_NORMAL_CAMERA)

    public static let emissionColor = AiTextureType(aiTextureType_EMISSION_COLOR)

    public static let metalness = AiTextureType(aiTextureType_METALNESS)

    public static let diffuseRoughness = AiTextureType(aiTextureType_DIFFUSE_ROUGHNESS)

    public static let ambientOcclusion = AiTextureType(aiTextureType_AMBIENT_OCCLUSION)

    /// Unknown texture
    ///
    /// A texture reference that does not match any of the definitions above is considered to be 'unknown'.
    /// It is still imported, but is excluded from any further postprocessing.
    public static let unknown = AiTextureType(aiTextureType_UNKNOWN)
}

extension AiTextureType: Equatable { }

extension AiTextureType: CustomDebugStringConvertible {
    public var debugDescription: String {
        String(cString: TextureTypeToString(aiTextureType(rawValue: self.rawValue)))
    }
}
