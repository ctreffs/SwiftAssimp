//
//  File.swift
//  
//
//  Created by Christian Treffs on 01.07.19.
//

import CAssimp

public struct AiMaterialProperty {
    var _property: aiMaterialProperty

    init(_ aiMaterialProperty: aiMaterialProperty) {
        _property = aiMaterialProperty
    }

    public var key: String? {
        return String(aiString: _property.mKey)
    }

    public var index: Int {
        return Int(_property.mIndex)
    }

    public var semantic: aiTextureType {
        return aiTextureType(_property.mSemantic)
    }

    public var type: aiPropertyTypeInfo {
        return _property.mType
    }

    var dataBuffer: UnsafeBufferPointer<Int8> {
        return UnsafeBufferPointer<Int8>(start: _property.mData, count: Int(_property.mDataLength))
    }

}
