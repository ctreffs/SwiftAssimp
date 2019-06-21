import XCTest
import Assimp

final class AssimpTests: XCTestCase {
    static var allTests = [
        ("testFailingInitializer", testFailingInitializer)
    ]

    func testFailingInitializer() {
        XCTAssertThrowsError(try AiScene(file: "<no useful path>"))
    }

}
