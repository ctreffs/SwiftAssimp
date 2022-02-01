import XCTest
@testable import Assimp
@_implementationOnly import CAssimp

final class InternalTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(aiGetVersionMajor(), 5)
        XCTAssertNotNil(aiGetVersionMinor())
        XCTAssertNotNil(aiGetVersionRevision())
    }

    func testVec3fFromAiVector3D() {
        let vec3f = aiVector3D(x: 1.2, y: 3.4, z: 5.6).vector
        XCTAssertEqual(vec3f, SIMD3<Float>(1.2, 3.4, 5.6))
        XCTAssertEqual(SIMD3<Float>(aiVector3D(x: 5.6, y: 3.4, z: 1.2)), SIMD3<Float>(5.6, 3.4, 1.2))
    }

    func testVec2fFromAiVector2D() {
        let vec2f = aiVector2D(x: 1.2, y: 3.4).vector
        XCTAssertEqual(vec2f, SIMD2<Float>(1.2, 3.4))
        XCTAssertEqual(SIMD2<Float>(aiVector2D(x: 5.6, y: 3.4)), SIMD2<Float>(5.6, 3.4))
    }
}
