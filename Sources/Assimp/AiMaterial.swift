//
//  AiMaterial.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiMaterial {
    private var _material: aiMaterial

    public struct Key: RawRepresentable {
        public var rawValue: String
        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
        public static let textureBase = Key(rawValue: _AI_MATKEY_TEXTURE_BASE)
        public static let uvwSourceBase = Key(rawValue: _AI_MATKEY_UVWSRC_BASE)
        public static let texOpBase = Key(rawValue: _AI_MATKEY_TEXOP_BASE)
        public static let mappingBase = Key(rawValue: _AI_MATKEY_MAPPING_BASE)
        public static let texBlendBase = Key(rawValue: _AI_MATKEY_TEXBLEND_BASE)
        public static let mappingModeUBase = Key(rawValue: _AI_MATKEY_MAPPINGMODE_U_BASE)
        public static let mappingModeVBase = Key(rawValue: _AI_MATKEY_MAPPINGMODE_V_BASE)
        public static let texMapAxisBase = Key(rawValue: _AI_MATKEY_TEXMAP_AXIS_BASE)
        public static let uvTransformBase = Key(rawValue: _AI_MATKEY_UVTRANSFORM_BASE)
        public static let texFlagsBase = Key(rawValue: _AI_MATKEY_TEXFLAGS_BASE)
    }

    init(_ aiMaterial: aiMaterial) {
        self._material = aiMaterial
    }

    public var numProperties: Int {
        return Int(_material.mNumProperties)
    }

    public var properties: [AiMaterialProperty] {
        guard let properties = _material.mProperties else {
            return []
        }

        return [aiMaterialProperty](UnsafeMutableBufferPointer<aiMaterialProperty>(start: properties.pointee,
                                                                                   count: numProperties)).map { AiMaterialProperty($0) }
    }

    /*
     * @param pMat Pointer to the input material. May not be NULL
     * @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
     * @param type Specifies the type of the texture to be retrieved (
     *    e.g. diffuse, specular, height map ...)
     * @param index Index of the texture to be retrieved.
     * @param pPropOut Pointer to receive a pointer to a valid aiMaterialProperty
     */
    public mutating func getMaterialProperty(key: Key, textureTypeSemantic type: UInt32 = 0, textureIndex index: UInt32 = 0) -> AiMaterialProperty {

        let ptr = UnsafeMutablePointer<UnsafePointer<aiMaterialProperty>?>.allocate(capacity: MemoryLayout<aiMaterialProperty>.stride)

        let result = aiGetMaterialProperty(&_material,
                                           key.rawValue,
                                           type,
                                           index,
                                           ptr)

        assert(result == aiReturn_SUCCESS)

        let property = ptr.pointee!.pointee

        return AiMaterialProperty(property)
    }

    public mutating func getMaterialString(key: Key, textureTypeSemantic type: UInt32 = 0, textureIndex index: UInt32 = 0) -> String? {
        var _aiString = aiString()
        let result = aiGetMaterialString(&_material, key.rawValue, type, index, &_aiString)

        assert(result == aiReturn_SUCCESS)

        return String(aiString: _aiString)
    }

    /*
     
     public var string: String? {
     var pOut: aiString = aiString()
     let result = aiGetMaterialString(&_material, _property.mKey, _property.mType, _property.mIndex, &pOut)
     assert(result == aiReturn_SUCCESS)
     return String(aiString: pOut)
     }
     */

    /*
     
     public var data: Int {
     switch type {
     case aiPTI_Float:
     
     case aiPTI_Double:
     
     case aiPTI_String:
     aiGetMaterialString(&_property, _property.mKey, _property.mType, _property.mIndex, <#T##pOut: UnsafeMutablePointer<aiString>!##UnsafeMutablePointer<aiString>!#>)
     case aiPTI_Integer:
     aiGetMaterialInteger(&_property, _property.mKey, _property.mType, _property.mIndex, <#T##pOut: UnsafeMutablePointer<Int32>!##UnsafeMutablePointer<Int32>!#>)
     case aiPTI_Buffer:
     aiGetMaterial
     }
     }
     */
}
