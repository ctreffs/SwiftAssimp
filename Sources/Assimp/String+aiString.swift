//
//  String+aiString.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public extension String {
    init?(aiString: aiString) {
        let cStringBuffer: UnsafePointer<CChar>? = withUnsafeBytes(of: aiString.data) { bytesPtr ->  UnsafePointer<CChar>? in
            if aiString.length <= 0 {
                return nil
            }
            guard let boundMemory: UnsafePointer<CChar> = bytesPtr.baseAddress?.bindMemory(to: CChar.self,
                                                                                           capacity: aiString.length) else {
                return nil
            }

            let stringBuffer = UnsafeBufferPointer<CChar>(start: boundMemory,
                                                          count: aiString.length)

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
            //.map { $0 > 0 ? $0 : Int8(0x20) } // this replaces all invalid characters with blank space
            .map { UTF8.CodeUnit($0) }

        self.init(decoding: codeUnits, as: UTF8.self)
    }

    /*
 
    init?(bytes: UnsafeMutablePointer<Int8>, length: Int) {
        
        let maybeString: String? = bytes.withMemoryRebound(to: UInt8.self, capacity: length) { start -> String? in
            let ptr = UnsafeBufferPointer<UInt8>.init(start: start, count: length)
            guard let (string, _) = String.decodeCString(ptr.baseAddress!,
                                                         as: UTF8.self,
                                                         repairingInvalidCodeUnits: true) else {
                return nil
            }
            return string
        }
        
        
        
        guard let string = maybeString else {
            return nil
        }
        
        self = string
        
    }
 */
}
