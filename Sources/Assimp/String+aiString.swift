//
//  String+aiString.swift
//
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

extension String {
    public init?(aiString: aiString) {
        let cStringBuffer: UnsafePointer<CChar>? = withUnsafeBytes(of: aiString.data) { bytesPtr ->  UnsafePointer<CChar>? in
            if aiString.length <= 0 {
                return nil
            }
            guard let boundMemory: UnsafePointer<CChar> = bytesPtr.baseAddress?.bindMemory(to: CChar.self,
                                                                                           capacity: Int(aiString.length)) else {
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

    public init?(bytes: UnsafeMutablePointer<Int8>, length: Int) {
        let bufferPtr = UnsafeMutableBufferPointer(start: bytes,
                                                   count: length)

        let codeUnits: [UTF8.CodeUnit] = bufferPtr
            //.map { $0 > 0 ? $0 : Int8(0x20) } // this replaces all invalid characters with blank space
            .map { UTF8.CodeUnit($0) }

        self.init(decoding: codeUnits, as: UTF8.self)
    }
}
