//
// AiTexture.swift
// SwiftAssimp
//
// Copyright © 2019-2022 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

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

    init(_ texture: aiTexture) {
        self.texture = texture
        filename = String(texture.mFilename)
        achFormatHint = CArray<CChar>.read(texture.achFormatHint) { body in
            guard let baseAddress = body.baseAddress else {
                return ""
            }
            return String(cString: baseAddress)
        }
        let width = Int(texture.mWidth)
        self.width = width
        let height = Int(texture.mHeight)
        self.height = height
        numPixels = {
            if height == 0 {
                let sizeInBytes = width
                return sizeInBytes / MemoryLayout<aiTexel>.stride
            } else {
                return width * height
            }
        }()
    }

    init?(_ aiTexture: aiTexture?) {
        guard let aiTexture = aiTexture else {
            return nil
        }

        self.init(aiTexture)
    }

    /// Texture original filename.
    ///
    /// Used to get the texture reference.
    public var filename: String?

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
    public var achFormatHint: String

    /// Width of the texture, in pixels
    ///
    /// If mHeight is zero the texture is compressed in a format like JPEG.
    /// In this case mWidth specifies the size of the memory area pcData is pointing to, in bytes.
    public var width: Int

    /// Height of the texture, in pixels
    ///
    /// If this value is zero, pcData points to a compressed texture in any format (e.g. JPEG).
    public var height: Int

    @inline(__always)
    public var isCompressed: Bool { height == 0 }

    /// Number of pixels in texture.
    public var numPixels: Int

    /// Data of the texture.
    ///
    /// Points to an array of mWidth * mHeight aiTexel's.
    /// The format of the texture data is always ARGB8888 to make the implementation for user of the library as easy as possible.
    /// If mHeight = 0 this is a pointer to a memory buffer of size mWidth containing the compressed texture data.
    /// Texel layout is BGRA.
    public lazy var textureData: [UInt8] = withUnsafeTextureData([UInt8].init)

    public mutating func withUnsafeTextureData<R>(_ body: (UnsafeBufferPointer<UInt8>) throws -> R) rethrows -> R {
        let count = numPixels * 4 // aiTexel(BGRA) * numPixel
        return try texture.pcData.withMemoryRebound(to: UInt8.self, capacity: count) { pBytes in
            try body(UnsafeBufferPointer<UInt8>(start: pBytes, count: count))
        }
    }
}
