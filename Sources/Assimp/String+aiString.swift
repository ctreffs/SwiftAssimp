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
}
