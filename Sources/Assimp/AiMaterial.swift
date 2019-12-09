//
//  AiMaterial.swift
//
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

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

        let properties = (0..<numProperties)
            .compactMap { material.mProperties[$0] }
            .map { AiMaterialProperty($0.pointee) }

        assert(properties.count == numProperties)

        return properties
    }

    public var typedProperties: [AiMaterialPropertyIdentifiable] {
        return properties.compactMap { prop -> AiMaterialPropertyIdentifiable? in
            switch (prop.type, prop.semantic) {
            case (.string, _):
                return AiMaterialPropertyString(prop)

            case (.float, _):
                return AiMaterialPropertyFloat(prop)

            case (.int, _):
                return AiMaterialPropertyInt(prop)

            case (.buffer, _):
                return AiMaterialPropertyBuffer(prop)

            case (.double, _):
                return AiMaterialPropertyDouble(prop)

            default:
                return nil
            }
        }
    }

    /*
     * @param pMat Pointer to the input material. May not be NULL
     * @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
     * @param type Specifies the type of the texture to be retrieved (
     *    e.g. diffuse, specular, height map ...)
     * @param index Index of the texture to be retrieved.
     * @param pPropOut Pointer to receive a pointer to a valid aiMaterialProperty
     */
    public mutating func getMaterialProperty(key: String, textureTypeSemantic type: UInt32 = 0, textureIndex index: UInt32 = 0) -> AiMaterialProperty {
        let ptr = UnsafeMutablePointer<UnsafePointer<aiMaterialProperty>?>.allocate(capacity: MemoryLayout<aiMaterialProperty>.stride)

        let result = aiGetMaterialProperty(&material,
                                           key,
                                           type,
                                           index,
                                           ptr)

        assert(result == aiReturn_SUCCESS)

        let property = ptr.pointee!.pointee

        return AiMaterialProperty(property)
    }

    public mutating func getMaterialString(key: String, textureTypeSemantic type: UInt32 = 0, textureIndex index: UInt32 = 0) -> String? {
        var string = aiString()
        let result = aiGetMaterialString(&material, key, type, index, &string)

        assert(result == aiReturn_SUCCESS)

        return String(aiString: string)
    }

    public mutating func getMaterialIntegerArray(key: String, textureTypeSemantic type: UInt32 = 0, textureIndex index: UInt32 = 0, pMax: inout UInt32) -> [Int32] {
        var ints = [Int32](repeating: 0, count: Int(pMax))

        let result = aiGetMaterialIntegerArray(&material, key, type, index, &ints, &pMax)
        assert(result == aiReturn_SUCCESS)

        return ints
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
