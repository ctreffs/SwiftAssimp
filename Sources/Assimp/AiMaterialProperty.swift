//
//  File.swift
//  
//
//  Created by Christian Treffs on 01.07.19.
//

import CAssimp

public struct AiMaterialProperty {

    public struct TypeInfo: RawRepresentable, CustomDebugStringConvertible {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        public static let float = TypeInfo(rawValue: aiPTI_Float.rawValue)
        public static let double = TypeInfo(rawValue: aiPTI_Double.rawValue)
        public static let string = TypeInfo(rawValue: aiPTI_String.rawValue)
        public static let int = TypeInfo(rawValue: aiPTI_Integer.rawValue)
        public static let buffer = TypeInfo(rawValue: aiPTI_Buffer.rawValue)

        public var debugDescription: String {
            switch self.rawValue {
            case TypeInfo.float.rawValue:
                return "float"
            case TypeInfo.double.rawValue:
                return "double"
            case TypeInfo.string.rawValue:
                return "string"
            case TypeInfo.int.rawValue:
                return "int"
            case TypeInfo.buffer.rawValue:
                return "buffer"
            default:
                return "unknown: \(rawValue)"
            }
        }

    }

    var _property: aiMaterialProperty

    init(_ aiMaterialProperty: aiMaterialProperty) {
        _property = aiMaterialProperty
    }

    /// Specifies the name of the property (key) Keys are generally case insensitive.
    public var key: String {
        return String(aiString: _property.mKey) ?? ""
    }

    /// Textures: Specifies the index of the texture.
    /// For non-texture properties, this member is always 0.
    public var index: Int {
        return Int(_property.mIndex)
    }

    /// Textures: Specifies their exact usage semantic.
    /// For non-texture properties, this member is always 0 (or, better-said, #aiTextureType_NONE).
    public var semantic: AiTextureType {
        return AiTextureType(rawValue: _property.mSemantic)
    }

    /// Type information for the property.
    ///
    /// Defines the data layout inside the data buffer. This is used
    /// by the library internally to perform debug checks and to
    /// utilize proper type conversions.
    ///
    /// (It's probably a hacky solution, but it works.)
    public var type: TypeInfo {
        return TypeInfo(rawValue: _property.mType.rawValue)
    }

    /// Size of the buffer mData is pointing to, in bytes.
    ///
    /// This value may not be 0.
    var dataLength: Int {
        return Int(_property.mDataLength)
    }

    /// Binary buffer to hold the property's value.
    /// The size of the buffer is always mDataLength.
    var dataBuffer: UnsafeBufferPointer<Int8> {
        return UnsafeBufferPointer<Int8>(start: _property.mData, count: dataLength)
    }

}

extension AiMaterialProperty: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
        <AiMaterialProperty
         - index: \(index)
         - key: \(key)
         - semantic: \(semantic)
         - type: \(type)
         - dataLength: \(dataLength)
        >
        """
    }
}
