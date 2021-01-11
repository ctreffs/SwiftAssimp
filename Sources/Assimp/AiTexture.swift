//
//  AiTexture.swift
//
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

/// Helper structure to describe an embedded texture
///
/// Normally textures are contained in external files but some file formats embed them directly in the model file.
/// There are two types of embedded textures:
/// 1. Uncompressed textures.
/// The color data is given in an uncompressed format.
/// 2. Compressed textures stored in a file format like png or jpg.
/// The raw file bytes are given so the application must utilize an image decoder (e.g. DevIL) to get access to the actual color data.
///
/// Embedded textures are referenced from materials using strings like "*0", "*1", etc. as the texture paths (a single asterisk character followed by the zero-based index of the texture in the aiScene::mTextures array).
public struct AiTexture {
    let texture: aiTexture

    public init(_ aiTexture: aiTexture) {
        texture = aiTexture
    }

    /// Texture original filename.
    ///
    /// Used to get the texture reference.
    public var filename: String? {
        String(aiString: texture.mFilename)
    }

    /// A hint from the loader to make it easier for applications
    /// to determine the type of embedded textures.
    ///
    /// If mHeight != 0 this member is show how data is packed. Hint will consist of
    /// two parts: channel order and channel bitness (count of the bits for every
    /// color channel). For simple parsing by the viewer it's better to not omit
    /// absent color channel and just use 0 for bitness. For example:
    /// 1. Image contain RGBA and 8 bit per channel, achFormatHint == "rgba8888";
    /// 2. Image contain ARGB and 8 bit per channel, achFormatHint == "argb8888";
    /// 3. Image contain RGB and 5 bit for R and B channels and 6 bit for G channel, achFormatHint == "rgba5650";
    /// 4. One color image with B channel and 1 bit for it, achFormatHint == "rgba0010";
    /// If mHeight == 0 then achFormatHint is set set to '\\0\\0\\0\\0' if the loader has no additional
    /// information about the texture file format used OR the
    /// file extension of the format without a trailing dot. If there
    /// are multiple file extensions for a format, the shortest
    /// extension is chosen (JPEG maps to 'jpg', not to 'jpeg').
    /// E.g. 'dds\\0', 'pcx\\0', 'jpg\\0'.  All characters are lower-case.
    /// The fourth character will always be '\\0'.
    public var achFormatHint: String {
        CArray<CChar>.read(texture.achFormatHint) { body in
            guard let baseAddress = body.baseAddress else {
                return ""
            }
            return String(cString: baseAddress)
        }
    }

    /// Width of the texture, in pixels
    ///
    /// If mHeight is zero the texture is compressed in a format like JPEG.
    /// In this case mWidth specifies the size of the memory area pcData is pointing to, in bytes.
    public var width: Int {
        Int(texture.mWidth)
    }

    /// Height of the texture, in pixels
    ///
    /// If this value is zero, pcData points to a compressed texture in any format (e.g. JPEG).
    public var height: Int {
        Int(texture.mHeight)
    }

    @inline(__always)
    public var isCompressed: Bool {
        height == 0
    }

    /// Number of pixels in texture.
    public var numPixels: Int {
        if isCompressed {
            let sizeInBytes = width
            return sizeInBytes / MemoryLayout<aiTexel>.stride
        } else {
            return width * height
        }
    }

    /// Data of the texture.
    ///
    /// Points to an array of mWidth * mHeight aiTexel's.
    /// The format of the texture data is always ARGB8888 to make the implementation for user of the library as easy as possible.
    /// If mHeight = 0 this is a pointer to a memory buffer of size mWidth containing the compressed texture data.
    public var pcData: [aiTexel] {
        [aiTexel](UnsafeMutableBufferPointer<aiTexel>(start: texture.pcData,
                                                      count: numPixels))
    }

    public var pcDataBGRA: [UInt8] {
        let pcData = self.pcData
        return [UInt8](unsafeUninitializedCapacity: MemoryLayout<aiTexel>.stride * numPixels) { buffer, written in
            for idx in 0..<numPixels {
                buffer[written] = pcData[idx].b
                written += 1
                buffer[written] = pcData[idx].g
                written += 1
                buffer[written] = pcData[idx].r
                written += 1
                buffer[written] = pcData[idx].a
                written += 1
            }
        }
    }

    public var pcDataRGBA: [UInt8] {
        let pcData = self.pcData
        return [UInt8](unsafeUninitializedCapacity: MemoryLayout<aiTexel>.stride * numPixels) { buffer, written in
            for idx in 0..<numPixels {
                buffer[written] = pcData[idx].r
                written += 1
                buffer[written] = pcData[idx].g
                written += 1
                buffer[written] = pcData[idx].b
                written += 1
                buffer[written] = pcData[idx].a
                written += 1
            }
        }
    }
}

public struct AiTextureType: RawRepresentable {
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

    /// PBR Materials
    ///
    /// PBR definitions from maya and other modelling packages now use this standard.
    /// This was originally introduced around 2012.
    /// Support for this is in game engines like Godot, Unreal or Unity3D.
    /// Modelling packages which use this are very common now.

    public static let baseColor = AiTextureType(rawValue: aiTextureType_BASE_COLOR.rawValue)

    public static let normalCamera = AiTextureType(rawValue: aiTextureType_NORMAL_CAMERA.rawValue)

    public static let emissionColor = AiTextureType(rawValue: aiTextureType_EMISSION_COLOR.rawValue)

    public static let metalness = AiTextureType(rawValue: aiTextureType_METALNESS.rawValue)

    public static let diffuseRoughness = AiTextureType(rawValue: aiTextureType_DIFFUSE_ROUGHNESS.rawValue)

    public static let ambientOcclusion = AiTextureType(rawValue: aiTextureType_AMBIENT_OCCLUSION.rawValue)

    /// Unknown texture
    ///
    /// A texture reference that does not match any of the definitions above is considered to be 'unknown'.
    /// It is still imported, but is excluded from any further postprocessing.
    public static let unknown = AiTextureType(rawValue: aiTextureType_UNKNOWN.rawValue)
}

extension AiTextureType {
    @inlinable var type: aiTextureType {
        aiTextureType(rawValue: rawValue)
    }
}

extension AiTextureType: Equatable { }

extension AiTextureType: CustomDebugStringConvertible {
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
        case .baseColor:
            return "baseColor"
        case .normalCamera:
            return "normalCamera"
        case .emissionColor:
            return "emissionColor"
        case .metalness:
            return "metalness"
        case .diffuseRoughness:
            return "diffuseRoughness"
        case .ambientOcclusion:
            return "ambientOcclusion"
        case .unknown:
            return "unknown"
        default:
            return "unexpected:\(rawValue)"
        }
    }
}
