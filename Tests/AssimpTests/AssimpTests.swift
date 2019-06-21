import XCTest
@testable import Assimp

final class AssimpTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Assimp().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
