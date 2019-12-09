//
//  AiMatKey.swift
//
//
//  Created by Christian Treffs on 06.12.19.
//

public struct AiMatKey: RawRepresentable {
    public let baseName: String
    public let texType: UInt32
    public let texIndex: UInt32
    public let rawValue: String

    init(base: Base, texType: AiTextureType = .none, texIndex: Int = 0) {
        self.rawValue = String(format: "%@,%d,%d", base.rawValue, texType.rawValue, texIndex)
        self.baseName = base.rawValue
        self.texType = texType.rawValue
        self.texIndex = UInt32(texIndex)
    }

    public init?(rawValue: String) {
        self.rawValue = rawValue
        self.baseName = ""
        self.texType = 0
        self.texIndex = 0
    }
}
extension AiMatKey: Equatable { }

extension AiMatKey {
    enum Base: String {
        case BLEND_FUNC_BASE = "$mat.blend"
        case BUMPSCALING_BASE = "$mat.bumpscaling"
        case COLOR_AMBIENT_BASE = "$clr.ambient"
        case COLOR_DIFFUSE_BASE = "$clr.diffuse"
        case COLOR_EMISSIVE_BASE = "$clr.emissive"
        case COLOR_REFLECTIVE_BASE = "$clr.reflective"
        case COLOR_SPECULAR_BASE = "$clr.specular"
        case COLOR_TRANSPARENT_BASE = "$clr.transparent"
        case ENABLE_WIREFRAME_BASE = "$mat.wireframe"
        case GLOBAL_BACKGROUND_IMAGE_BASE = "?bg.global"
        case MAPPING_BASE = "$tex.mapping"
        case MAPPINGMODE_U_BASE = "$tex.mapmodeu"
        case MAPPINGMODE_V_BASE = "$tex.mapmodev"
        case NAME_BASE = "?mat.name"
        case OPACITY_BASE = "$mat.opacity"
        case REFLECTIVITY_BASE = "$mat.reflectivity"
        case REFRACTI_BASE = "$mat.refracti"
        case SHADING_MODEL_BASE = "$mat.shadingm"
        case SHININESS_BASE = "$mat.shininess"
        case SHININESS_STRENGTH_BASE = "$mat.shinpercent"
        case TEXBLEND_BASE = "$tex.blend"
        case TEXFLAGS_BASE = "$tex.flags"
        case TEXMAP_AXIS_BASE = "$tex.mapaxis"
        case TEXOP_BASE = "$tex.op"
        case TEXTURE_BASE = "$tex.file"
        case TWOSIDED_BASE = "$mat.twosided"
        case UVTRANSFORM_BASE = "$tex.uvtrafo"
        case UVWSRC_BASE = "$tex.uvwsrc"

        case GLTF_TEXTURE_TEXCOORD_BASE = "$tex.file.texCoord"
        case GLTF_MAPPINGNAME_BASE = "$tex.mappingname"
        case GLTF_MAPPINGID_BASE = "$tex.mappingid"
        case GLTF_MAPPINGFILTER_MAG_BASE = "$tex.mappingfiltermag"
        case GLTF_MAPPINGFILTER_MIN_BASE = "$tex.mappingfiltermin"
        case GLTF_SCALE_BASE = "$tex.scale"
        case GLTF_STRENGTH_BASE = "$tex.strength"

        case GLTF_PBRMETALLICROUGHNESS_BASE_COLOR_FACTOR = "$mat.gltf.pbrMetallicRoughness.baseColorFactor"
        case GLTF_PBRMETALLICROUGHNESS_METALLIC_FACTOR = "$mat.gltf.pbrMetallicRoughness.metallicFactor"
        case GLTF_PBRMETALLICROUGHNESS_ROUGHNESS_FACTOR = "$mat.gltf.pbrMetallicRoughness.roughnessFactor"
        case GLTF_ALPHAMODE = "$mat.gltf.alphaMode"
        case GLTF_ALPHACUTOFF =  "$mat.gltf.alphaCutoff"
        case GLTF_PBRSPECULARGLOSSINESS = "$mat.gltf.pbrSpecularGlossiness"
        case GLTF_PBRSPECULARGLOSSINESS_GLOSSINESS_FACTOR = "$mat.gltf.pbrMetallicRoughness.glossinessFactor"
        case GLTF_UNLIT = "$mat.gltf.unlit"
    }
}

extension AiMatKey {
    public static let BLEND_FUNC: AiMatKey = .init(base: .BLEND_FUNC_BASE)
    public static let BUMPSCALING: AiMatKey = .init(base: .BUMPSCALING_BASE)
    public static let COLOR_AMBIENT: AiMatKey = .init(base: .COLOR_AMBIENT_BASE)
    public static let COLOR_DIFFUSE: AiMatKey = .init(base: .COLOR_DIFFUSE_BASE)
    public static let COLOR_EMISSIVE: AiMatKey = .init(base: .COLOR_EMISSIVE_BASE)
    public static let COLOR_REFLECTIVE: AiMatKey = .init(base: .COLOR_REFLECTIVE_BASE)
    public static let COLOR_SPECULAR: AiMatKey = .init(base: .COLOR_SPECULAR_BASE)
    public static let COLOR_TRANSPARENT: AiMatKey = .init(base: .COLOR_TRANSPARENT_BASE)
    public static let ENABLE_WIREFRAME: AiMatKey = .init(base: .ENABLE_WIREFRAME_BASE)
    public static let GLOBAL_BACKGROUND_IMAGE: AiMatKey = .init(base: .GLOBAL_BACKGROUND_IMAGE_BASE)
    public static let MAPPING: AiMatKey = .init(base: .MAPPING_BASE)
    public static let MAPPINGMODE_U: AiMatKey = .init(base: .MAPPINGMODE_U_BASE)
    public static let MAPPINGMODE_V: AiMatKey = .init(base: .MAPPINGMODE_V_BASE)
    public static let NAME: AiMatKey = .init(base: .NAME_BASE)
    public static let OPACITY: AiMatKey = .init(base: .OPACITY_BASE)
    public static let REFLECTIVITY: AiMatKey = .init(base: .REFLECTIVITY_BASE)
    public static let REFRACTI: AiMatKey = .init(base: .REFRACTI_BASE)
    public static let SHADING_MODEL: AiMatKey = .init(base: .SHADING_MODEL_BASE)
    public static let SHININESS: AiMatKey = .init(base: .SHININESS_BASE)
    public static let SHININESS_STRENGTH: AiMatKey = .init(base: .SHININESS_STRENGTH_BASE)
    public static let TEXBLEND: AiMatKey = .init(base: .TEXBLEND_BASE)
    public static let TEXFLAGS: AiMatKey = .init(base: .TEXFLAGS_BASE)
    public static let TEXMAP_AXIS: AiMatKey = .init(base: .TEXMAP_AXIS_BASE)
    public static let TEXOP: AiMatKey = .init(base: .TEXOP_BASE)
    public static let TEXTURE: AiMatKey = .init(base: .TEXTURE_BASE)
    public static let TWOSIDED: AiMatKey = .init(base: .TWOSIDED_BASE)
    public static let UVTRANSFORM: AiMatKey = .init(base: .UVTRANSFORM_BASE)
    public static let UVWSRC: AiMatKey = .init(base: .UVWSRC_BASE)

    public static let GLTF_PBRMETALLICROUGHNESS_BASE_COLOR_FACTOR: AiMatKey = .init(base: .GLTF_PBRMETALLICROUGHNESS_BASE_COLOR_FACTOR)
    public static let GLTF_PBRMETALLICROUGHNESS_METALLIC_FACTOR: AiMatKey = .init(base: .GLTF_PBRMETALLICROUGHNESS_METALLIC_FACTOR)
    public static let GLTF_PBRMETALLICROUGHNESS_ROUGHNESS_FACTOR: AiMatKey = .init(base: .GLTF_PBRMETALLICROUGHNESS_ROUGHNESS_FACTOR)
    public static var GLTF_PBRMETALLICROUGHNESS_BASE_COLOR_TEXTURE: AiMatKey = { .init(base: .TEXTURE_BASE, texType: .diffuse, texIndex: 1) }()
    public static let GLTF_PBRMETALLICROUGHNESS_METALLICROUGHNESS_TEXTURE: AiMatKey = { .init(base: .TEXTURE_BASE, texType: .unknown, texIndex: 0) }()
    public static let GLTF_ALPHAMODE: AiMatKey = .init(base: .GLTF_ALPHAMODE)
    public static let GLTF_ALPHACUTOFF: AiMatKey = .init(base:  .GLTF_ALPHACUTOFF)
    public static let GLTF_PBRSPECULARGLOSSINESS: AiMatKey = .init(base:  .GLTF_PBRSPECULARGLOSSINESS)
    public static let GLTF_PBRSPECULARGLOSSINESS_GLOSSINESS_FACTOR: AiMatKey = .init(base:  .GLTF_PBRSPECULARGLOSSINESS_GLOSSINESS_FACTOR)
    public static let GLTF_UNLIT: AiMatKey = .init(base: .GLTF_UNLIT)

    public static func BLEND_FUNC(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .BLEND_FUNC_BASE, texType: texType, texIndex: texIndex) }
    public static func BUMPSCALING(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .BUMPSCALING_BASE, texType: texType, texIndex: texIndex) }
    public static func COLOR_AMBIENT(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .COLOR_AMBIENT_BASE, texType: texType, texIndex: texIndex) }
    public static func COLOR_DIFFUSE(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .COLOR_DIFFUSE_BASE, texType: texType, texIndex: texIndex) }
    public static func COLOR_EMISSIVE(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .COLOR_EMISSIVE_BASE, texType: texType, texIndex: texIndex) }
    public static func COLOR_REFLECTIVE(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .COLOR_REFLECTIVE_BASE, texType: texType, texIndex: texIndex) }
    public static func COLOR_SPECULAR(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .COLOR_SPECULAR_BASE, texType: texType, texIndex: texIndex) }
    public static func COLOR_TRANSPARENT(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .COLOR_TRANSPARENT_BASE, texType: texType, texIndex: texIndex) }
    public static func ENABLE_WIREFRAME(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .ENABLE_WIREFRAME_BASE, texType: texType, texIndex: texIndex) }
    public static func GLOBAL_BACKGROUND_IMAGE(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .GLOBAL_BACKGROUND_IMAGE_BASE, texType: texType, texIndex: texIndex) }
    public static func MAPPING(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .MAPPING_BASE, texType: texType, texIndex: texIndex) }
    public static func MAPPINGMODE_U(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .MAPPINGMODE_U_BASE, texType: texType, texIndex: texIndex) }
    public static func MAPPINGMODE_V(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .MAPPINGMODE_V_BASE, texType: texType, texIndex: texIndex) }
    public static func NAME(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .NAME_BASE, texType: texType, texIndex: texIndex) }
    public static func OPACITY(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .OPACITY_BASE, texType: texType, texIndex: texIndex) }
    public static func REFLECTIVITY(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .REFLECTIVITY_BASE, texType: texType, texIndex: texIndex) }
    public static func REFRACTI(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .REFRACTI_BASE, texType: texType, texIndex: texIndex) }
    public static func SHADING_MODEL(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .SHADING_MODEL_BASE, texType: texType, texIndex: texIndex) }
    public static func SHININESS(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .SHININESS_BASE, texType: texType, texIndex: texIndex) }
    public static func SHININESS_STRENGTH(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .SHININESS_STRENGTH_BASE, texType: texType, texIndex: texIndex) }
    public static func TEXBLEND(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .TEXBLEND_BASE, texType: texType, texIndex: texIndex) }
    public static func TEXFLAGS(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .TEXFLAGS_BASE, texType: texType, texIndex: texIndex) }
    public static func TEXMAP_AXIS(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .TEXMAP_AXIS_BASE, texType: texType, texIndex: texIndex) }
    public static func TEXOP(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .TEXOP_BASE, texType: texType, texIndex: texIndex) }
    public static func TEXTURE(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .TEXTURE_BASE, texType: texType, texIndex: texIndex) }
    public static func TWOSIDED(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .TWOSIDED_BASE, texType: texType, texIndex: texIndex) }
    public static func UVTRANSFORM(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .UVTRANSFORM_BASE, texType: texType, texIndex: texIndex) }
    public static func UVWSRC(_ texType: AiTextureType, _ texIndex: Int) -> AiMatKey { return .init(base: .UVWSRC_BASE, texType: texType, texIndex: texIndex) }
}
