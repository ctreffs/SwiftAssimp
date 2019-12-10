//
//  AiMaterial.swift
//
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

// Ref: https://github.com/helix-toolkit/helix-toolkit/blob/master/Source/HelixToolkit.SharpDX.Assimp.Shared/ImporterPartial_Material.cs
public struct AiMaterial {
    var material: aiMaterial

    init(_ aiMaterial: aiMaterial) {
        self.material = aiMaterial
    }

    public init() {
        self.material = aiMaterial()
    }

    /// Number of properties in the data base
    public var numProperties: Int {
        return Int(material.mNumProperties)
    }

    /// Storage allocated
    public var numAllocated: Int {
        return Int(material.mNumAllocated)
    }

    /// List of all material properties loaded.
    public var properties: [AiMaterialProperty] {
        guard numProperties > 0 else {
            return []
        }
        return [AiMaterialProperty](unsafeUninitializedCapacity: numProperties) { buffer, written in
            for idx in 0..<numProperties {
                if let prop = material.mProperties[idx] {
                    buffer[idx] = AiMaterialProperty(prop.pointee)
                    written += 1
                }
            }
        }
    }

    public var typedProperties: [AiMaterialPropertyIdentifiable] {
        return properties.compactMap { prop -> AiMaterialPropertyIdentifiable? in
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
        return withUnsafePointer(to: self.material) { matPtr -> AiMaterialProperty? in
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
        return withUnsafePointer(to: material) {
            Int(aiGetMaterialTextureCount($0, texType.type))
        }
    }

    public func getMaterialTexture(texType: AiTextureType, texIndex: Int) -> String? {
        return withUnsafePointer(to: material) { (matPtr: UnsafePointer<aiMaterial>) -> String? in
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

            return String(aiString: path)
        }
    }

    public func getMaterialString(_ key: AiMatKey) -> String? {
        return withUnsafePointer(to: material) { matPtr -> String? in
            var string = aiString()
            let result = aiGetMaterialString(matPtr,
                                             key.baseName,
                                             key.texType,
                                             key.texIndex,
                                             &string)

            guard result == aiReturn_SUCCESS else {
                return nil
            }

            return String(aiString: string)
        }
    }

    public func getMaterialColor(_ key: AiMatKey) -> SIMD4<ai_real>? {
        return withUnsafePointer(to: material) { matPtr in
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

    public func getMaterialFloatArray(_ key: AiMatKey) -> [ai_real]? {
        return withUnsafePointer(to: material) { matPtr in
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
        return withUnsafePointer(to: material) { matPtr in
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
    @inlinable public var name: String? { return getMaterialString(.NAME) }

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

    @inlinable public var blendMode: aiBlendMode? {
        guard let int = getMaterialProperty(.BLEND_FUNC)?.int.first else {
            return nil
        }

        return aiBlendMode(UInt32(int))
    }
}

extension AiMaterial: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
        <AiMaterial
        - numProperties: \(numProperties)
        - numAllocated: \(numAllocated)
        - properties: \(properties.debugDescription)
        >
        """
    }
}

extension AiMaterial: Equatable {
    public static func == (lhs: AiMaterial, rhs: AiMaterial) -> Bool {
        return lhs.numAllocated == rhs.numAllocated &&
            lhs.numProperties == rhs.numProperties &&
            lhs.properties == rhs.properties
    }
}
