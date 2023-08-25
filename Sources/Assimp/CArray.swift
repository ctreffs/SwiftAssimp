//
// CArray.swift
// SwiftAssimp
//
// Copyright © 2019-2023 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

enum CArray<T> {
    @discardableResult
    @_transparent
    static func write<C, O>(_ cArray: inout C, _ body: (UnsafeMutableBufferPointer<T>) throws -> O) rethrows -> O {
        try withUnsafeMutablePointer(to: &cArray) {
            try body(UnsafeMutableBufferPointer<T>(start: UnsafeMutableRawPointer($0).assumingMemoryBound(to: T.self),
                                                   count: MemoryLayout<C>.stride / MemoryLayout<T>.stride))
        }
    }

    @discardableResult
    @_transparent
    static func read<C, O>(_ cArray: C, _ body: (UnsafeBufferPointer<T>) throws -> O) rethrows -> O {
        try withUnsafePointer(to: cArray) {
            try body(UnsafeBufferPointer<T>(start: UnsafeRawPointer($0).assumingMemoryBound(to: T.self),
                                            count: MemoryLayout<C>.stride / MemoryLayout<T>.stride))
        }
    }
}
