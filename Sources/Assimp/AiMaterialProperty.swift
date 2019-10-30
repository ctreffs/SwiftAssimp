//
//  AiMaterialProperty.swift
//
//
//  Created by Christian Treffs on 01.07.19.
//

import CAssimp

public protocol AiMaterialPropertyIdentifiable {
    /// Specifies the name of the property (key) Keys are generally case insensitive.
    var key: String { get }

    /// Textures: Specifies the index of the texture.
    /// For non-texture properties, this member is always 0.
    var index: Int { get }

    /// Textures: Specifies their exact usage semantic.
    /// For non-texture properties, this member is always 0 (or, better-said, #aiTextureType_NONE).
    var semantic: AiTextureType { get }

    /// Type information for the property.
    ///
    /// Defines the data layout inside the data buffer. This is used
    /// by the library internally to perform debug checks and to
    /// utilize proper type conversions.
    ///
    /// (It's probably a hacky solution, but it works.)
    var type: AiMaterialProperty.TypeInfo { get }

    init(_ property: AiMaterialProperty)
}

public struct AiMaterialProperty: AiMaterialPropertyIdentifiable {
    public struct TypeInfo: RawRepresentable, Equatable, CustomDebugStringConvertible {
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
            switch self {
            case .float:
                return "float"
            case .double:
                return "double"
            case .string:
                return "string"
            case .int:
                return "int"
            case .buffer:
                return "buffer"
            default:
                return "unknown: \(rawValue)"
            }
        }
    }

    var property: aiMaterialProperty

    init(_ aiMaterialProperty: aiMaterialProperty) {
        property = aiMaterialProperty
    }

    public init(_ property: AiMaterialProperty) {
        self.property = property.property
    }

    /// Specifies the name of the property (key) Keys are generally case insensitive.
    public var key: String {
        return String(aiString: property.mKey) ?? ""
    }

    /// Textures: Specifies the index of the texture.
    /// For non-texture properties, this member is always 0.
    public var index: Int {
        return Int(property.mIndex)
    }

    /// Textures: Specifies their exact usage semantic.
    /// For non-texture properties, this member is always 0 (or, better-said, #aiTextureType_NONE).
    public var semantic: AiTextureType {
        return AiTextureType(rawValue: property.mSemantic)
    }

    /// Type information for the property.
    ///
    /// Defines the data layout inside the data buffer. This is used
    /// by the library internally to perform debug checks and to
    /// utilize proper type conversions.
    ///
    /// (It's probably a hacky solution, but it works.)
    public var type: TypeInfo {
        return TypeInfo(rawValue: property.mType.rawValue)
    }

    /// Size of the buffer mData is pointing to, in bytes.
    ///
    /// This value may not be 0.
    public var dataLength: Int {
        return Int(property.mDataLength)
    }

    /// Binary buffer to hold the property's value.
    /// The size of the buffer is always mDataLength.
    public var dataBuffer: UnsafeBufferPointer<Int8> {
        return UnsafeBufferPointer<Int8>(start: property.mData,
                                         count: dataLength)
    }

    public var string: String? {
        guard type == .string, dataLength > 0, let ptr = property.mData else {
            return nil
        }
        // FIXME: we cut out the array length field and the terminating NULL of the aiString - this is not nice!
        let p2 = ptr.advanced(by: MemoryLayout<Int32>.stride)

        return String(bytes: p2, length: dataLength - 1 - MemoryLayout<Int32>.stride)
    }

    internal func getString(pMat: UnsafePointer<aiMaterial>) -> String? {
        var pOut = aiString()

        let result = aiGetMaterialString(pMat,
                                         key.withCString { $0 },
                                         property.mType.rawValue,
                                         property.mIndex,
                                         &pOut)

        guard result == aiReturn_SUCCESS else {
            return nil
        }
        return String(aiString: pOut)
    }

    public var double: [Double] {
        guard type == .double, dataLength > 0, let ptr = property.mData else {
            return []
        }

        return (0..<dataLength).map { Double(ptr[$0]) }
    }

    public var float: [Float32] {
        guard type == .float, dataLength > 0, let ptr = property.mData else {
            return []
        }

        return (0..<dataLength).map { Float32(ptr[$0]) }
    }

    public var int: [Int32] {
        guard type == .int, dataLength > 0, let ptr = property.mData else {
            return []
        }

        return (0..<dataLength).map { Int32(ptr[$0]) }
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

extension AiMaterialProperty: Equatable {
    public static func == (lhs: AiMaterialProperty, rhs: AiMaterialProperty) -> Bool {
        return lhs.key == rhs.key &&
            lhs.index == rhs.index &&
            lhs.semantic == rhs.semantic &&
            lhs.type == rhs.type &&
            lhs.dataLength == rhs.dataLength
    }
}

public struct AiMaterialPropertyString: AiMaterialPropertyIdentifiable, CustomDebugStringConvertible {
    public let key: String
    public let index: Int
    public let semantic: AiTextureType
    public let type: AiMaterialProperty.TypeInfo
    public let string: String

    public init(_ property: AiMaterialProperty) {
        key = property.key
        index = property.index
        semantic = property.semantic
        type = property.type
        string = property.string!
    }

    public var debugDescription: String {
        return """
        <AiMaterialPropertyString
        - index: \(index)
        - key: \(key)
        - semantic: \(semantic)
        - type: \(type)
        - string: \(string)
        >
        """
    }
}

public struct AiMaterialPropertyBuffer: AiMaterialPropertyIdentifiable, CustomDebugStringConvertible {
    public let key: String
    public let index: Int
    public let semantic: AiTextureType
    public let type: AiMaterialProperty.TypeInfo
    public let buffer: UnsafeBufferPointer<Int8>
    public let length: Int

    public init(_ property: AiMaterialProperty) {
        key = property.key
        index = property.index
        semantic = property.semantic
        type = property.type
        buffer = property.dataBuffer
        length = property.dataLength
    }

    public var debugDescription: String {
        return """
        <AiMaterialPropertyBuffer
        - index: \(index)
        - key: \(key)
        - semantic: \(semantic)
        - type: \(type)
        - bufferLength: \(length)
        >
        """
    }
}

public struct AiMaterialPropertyDouble: AiMaterialPropertyIdentifiable, CustomDebugStringConvertible {
    public let key: String
    public let index: Int
    public let semantic: AiTextureType
    public let type: AiMaterialProperty.TypeInfo
    public let doubles: [Double]

    public init(_ property: AiMaterialProperty) {
        key = property.key
        index = property.index
        semantic = property.semantic
        type = property.type
        doubles = property.double
    }

    public var debugDescription: String {
        return """
        <AiMaterialPropertyDouble
        - index: \(index)
        - key: \(key)
        - semantic: \(semantic)
        - type: \(type)
        - double: \(doubles.map { $0 })
        >
        """
    }
}

public struct AiMaterialPropertyFloat: AiMaterialPropertyIdentifiable, CustomDebugStringConvertible {
    public let key: String
    public let index: Int
    public let semantic: AiTextureType
    public let type: AiMaterialProperty.TypeInfo
    public let floats: [Float32]

    public init(_ property: AiMaterialProperty) {
        key = property.key
        index = property.index
        semantic = property.semantic
        type = property.type
        floats = property.float
    }

    public var debugDescription: String {
        return """
        <AiMaterialPropertyFloat
        - index: \(index)
        - key: \(key)
        - semantic: \(semantic)
        - type: \(type)
        - float: \(floats.map { $0 })
        >
        """
    }
}

public struct AiMaterialPropertyInt: AiMaterialPropertyIdentifiable, CustomDebugStringConvertible {
    public let key: String
    public let index: Int
    public let semantic: AiTextureType
    public let type: AiMaterialProperty.TypeInfo
    public let ints: [Int32]

    public init(_ property: AiMaterialProperty) {
        key = property.key
        index = property.index
        semantic = property.semantic
        type = property.type
        ints = property.int
    }

    public var debugDescription: String {
        return """
        <AiMaterialPropertyInt
        - index: \(index)
        - key: \(key)
        - semantic: \(semantic)
        - type: \(type)
        - int: \(ints.map { $0 })
        >
        """
    }
}
