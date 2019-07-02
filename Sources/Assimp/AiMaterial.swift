//
//  AiMaterial.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiMaterial {
    private var _material: aiMaterial

    init(_ aiMaterial: aiMaterial) {
        self._material = aiMaterial
    }

    public var numProperties: Int {
        return Int(_material.mNumProperties)
    }

    public var properties: [AiMaterialProperty] {
        [aiMaterialProperty](UnsafeMutableBufferPointer<aiMaterialProperty>(start: _material.mProperties?.pointee,
                                                                            count: numProperties)).map { AiMaterialProperty($0) }
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
