//
// String+aiString.swift
// SwiftAssimp
//
// Copyright © 2019-2023 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

extension String {
    init?(_ aiString: aiString) {
        let cStringBuffer: UnsafePointer<CChar>? = withUnsafeBytes(of: aiString.data) { bytesPtr -> UnsafePointer<CChar>? in
            if aiString.length <= 0 {
                return nil
            }
            guard let boundMemory: UnsafePointer<CChar> = bytesPtr.baseAddress?.bindMemory(to: CChar.self,
                                                                                           capacity: Int(aiString.length))
            else {
                return nil
            }

            let stringBuffer = UnsafeBufferPointer<CChar>(start: boundMemory,
                                                          count: Int(aiString.length))

            return stringBuffer.baseAddress
        }

        guard let cStringBufferStart = cStringBuffer else {
            return nil
        }

        self.init(cString: cStringBufferStart)
    }

    init?(bytes: UnsafeMutablePointer<Int8>, length: Int) {
        let bufferPtr = UnsafeMutableBufferPointer(start: bytes,
                                                   count: length)

        let codeUnits: [UTF8.CodeUnit] = bufferPtr
            // .map { $0 > 0 ? $0 : Int8(0x20) } // this replaces all invalid characters with blank space
            .map { UTF8.CodeUnit($0) }

        self.init(decoding: codeUnits, as: UTF8.self)
    }
}
