//
// AiMaterial.swift
// SwiftAssimp
//
// Copyright © 2019-2022 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

// Ref: https://github.com/helix-toolkit/helix-toolkit/blob/master/Source/HelixToolkit.SharpDX.Assimp.Shared/ImporterPartial_Material.cs
public struct AiMaterial {
    let material: aiMaterial

    init(_ material: aiMaterial) {
        self.material = material
        let numProperties = Int(material.mNumProperties)
        self.numProperties = numProperties
        let numAllocated = Int(material.mNumAllocated)
        self.numAllocated = numAllocated
        properties = {
            guard numProperties > 0 else {
                return []
            }
            return [AiMaterialProperty](unsafeUninitializedCapacity: numProperties) { buffer, written in
                for idx in 0 ..< numProperties {
                    if let prop = material.mProperties[idx] {
                        buffer[idx] = AiMaterialProperty(prop.pointee)
                        written += 1
                    }
                }
            }
        }()
    }

    init?(_ mat: aiMaterial?) {
        guard let mat = mat else {
            return nil
        }
        self.init(mat)
    }

    /// Number of properties in the data base
    public var numProperties: Int

    /// Storage allocated
    public var numAllocated: Int

    /// List of all material properties loaded.
    public var properties: [AiMaterialProperty]

    public lazy var typedProperties: [AiMaterialPropertyIdentifiable] = properties.compactMap { prop -> AiMaterialPropertyIdentifiable? in
        switch prop.type {
        case .string:
            return AiMaterialPropertyString(prop)

        case .float:
            return AiMaterialPropertyFloat(prop)

        case .int:
            return AiMaterialPropertyInt(prop)

        case .buffer:
            return AiMaterialPropertyBuffer(prop)

        case .double:
            return AiMaterialPropertyDouble(prop)

        default:
            return nil
        }
    }

    /*
     - aiGetMaterialProperty
     - aiGetMaterialTextureCount
     - aiGetMaterialTexture
     - aiGetMaterialString
     - aiGetMaterialColor

     - aiGetMaterialFloat
     - aiGetMaterialFloatArray
     - aiGetMaterialInteger
     - aiGetMaterialIntegerArray
     - aiGetMaterialUVTransform
     - aiGetMaterialXXX
     */
    public func getMaterialProperty(_ key: AiMatKey) -> AiMaterialProperty? {
        withUnsafePointer(to: material) { matPtr -> AiMaterialProperty? in
            let matPropPtr = UnsafeMutablePointer<UnsafePointer<aiMaterialProperty>?>.allocate(capacity: MemoryLayout<aiMaterialProperty>.stride)
            defer {
                matPropPtr.deinitialize(count: 1)
                matPropPtr.deallocate()
            }

            let result = aiGetMaterialProperty(matPtr,
                                               key.baseName,
                                               key.texType,
                                               key.texIndex,
                                               matPropPtr)

            guard result == aiReturn_SUCCESS, let property = matPropPtr.pointee?.pointee else {
                return nil
            }
            return AiMaterialProperty(property)
        }
    }

    /// Get the number of textures for a particular texture type.
    public func getMaterialTextureCount(texType: AiTextureType) -> Int {
        withUnsafePointer(to: material) {
            Int(aiGetMaterialTextureCount($0, texType.type))
        }
    }

    public func getMaterialTexture(texType: AiTextureType, texIndex: Int) -> String? {
        withUnsafePointer(to: material) { (matPtr: UnsafePointer<aiMaterial>) -> String? in
            var path = aiString()
            // NOTE: the properties do not seem to be working
            var mapping: aiTextureMapping = aiTextureMapping_UV
            var uvIndex: UInt32 = 0
            var blend: ai_real = 0.0
            var texOp: aiTextureOp = aiTextureOp_Multiply
            var mapmode: [aiTextureMapMode] = [aiTextureMapMode_Wrap, aiTextureMapMode_Wrap]
            var flags: UInt32 = 0
            let result = aiGetMaterialTexture(matPtr,
                                              texType.type,
                                              UInt32(texIndex),
                                              &path,
                                              &mapping,
                                              &uvIndex,
                                              &blend,
                                              &texOp,
                                              &mapmode,
                                              &flags)

            guard result == aiReturn_SUCCESS else {
                return nil
            }

            return String(path)
        }
    }

    public func getMaterialString(_ key: AiMatKey) -> String? {
        withUnsafePointer(to: material) { matPtr -> String? in
            var string = aiString()
            let result = aiGetMaterialString(matPtr,
                                             key.baseName,
                                             key.texType,
                                             key.texIndex,
                                             &string)

            guard result == aiReturn_SUCCESS else {
                return nil
            }

            return String(string)
        }
    }

    public func getMaterialColor(_ key: AiMatKey) -> SIMD4<AiReal>? {
        withUnsafePointer(to: material) { matPtr in
            var color = aiColor4D()
            let result = aiGetMaterialColor(matPtr,
                                            key.baseName,
                                            key.texType,
                                            key.texIndex,
                                            &color)
            guard result == aiReturn_SUCCESS else {
                return nil
            }
            return SIMD4<Float>(color.r, color.g, color.b, color.a)
        }
    }

    public func getMaterialFloatArray(_ key: AiMatKey) -> [AiReal]? {
        withUnsafePointer(to: material) { matPtr in
            let count = MemoryLayout<aiUVTransform>.stride / MemoryLayout<ai_real>.stride
            return [ai_real](unsafeUninitializedCapacity: count) { buffer, written in
                var pMax: UInt32 = 0
                let result = aiGetMaterialFloatArray(matPtr,
                                                     key.baseName,
                                                     key.texType,
                                                     key.texIndex,
                                                     buffer.baseAddress!,
                                                     &pMax)
                guard result == aiReturn_SUCCESS else {
                    return
                }

                written = Int(pMax)
            }
        }
    }

    public func getMaterialIntegerArray(_ key: AiMatKey) -> [Int32] {
        withUnsafePointer(to: material) { matPtr in
            [Int32](unsafeUninitializedCapacity: 4) { buffer, written in
                var pMax: UInt32 = 0
                let result = aiGetMaterialIntegerArray(matPtr,
                                                       key.baseName,
                                                       key.texType,
                                                       key.texIndex,
                                                       buffer.baseAddress!,
                                                       &pMax)

                guard result == aiReturn_SUCCESS, pMax > 0 else {
                    return
                }

                written = Int(pMax)
            }
        }
    }
}

extension AiMaterial {
    @inlinable public var name: String? { getMaterialString(.NAME) }

    @inlinable public var shadingModel: AiShadingMode? {
        guard let int = getMaterialProperty(.SHADING_MODEL)?.int.first else {
            return nil
        }
        return AiShadingMode(rawValue: UInt32(int))
    }

    @inlinable public var cullBackfaces: Bool? {
        guard let int = getMaterialProperty(.TWOSIDED)?.int.first else {
            return nil
        }

        return !(int == 1)
    }

    public var blendMode: AiBlendMode? {
        guard let int = getMaterialProperty(.BLEND_FUNC)?.int.first else {
            return nil
        }

        return AiBlendMode(aiBlendMode(UInt32(int)))
    }
}

/// Defines alpha-blend flags.
///
/// If you're familiar with OpenGL or D3D, these flags aren't new to you.
/// They define *how* the final color value of a pixel is computed, basing
/// on the previous color at that pixel and the new color value from the
/// material.
/// The blend formula is:
/// ```
///   SourceColor * SourceBlend + DestColor * DestBlend
/// ```
/// where DestColor is the previous color in the frame-buffer at this
/// position and SourceColor is the material color before the transparency
/// calculation.<br>
/// This corresponds to the #AI_MATKEY_BLEND_FUNC property.
///
public enum AiBlendMode {
    /// Default blend mode
    ///
    /// Formula:
    /// ```
    /// SourceColor*SourceAlpha + DestColor*(1-SourceAlpha)
    /// ```
    case `default`

    ///  Additive blending
    ///
    /// Formula:
    /// ```
    /// SourceColor*1 + DestColor*1
    /// ```
    case additive

    init?(_ blendMode: aiBlendMode) {
        switch blendMode {
        case aiBlendMode_Default:
            self = .default

        case aiBlendMode_Additive:
            self = .additive

        default:
            return nil
        }
    }
}
