import XCTest
import Assimp
import CAssimp

final class AssimpTests: XCTestCase {

    static var allTests = [
        ("testFailingInitializer", testFailingInitializer)
    ]
    var standfordBunnyObjFile: URL!

    override func setUp() {
        super.setUp()
        let fm = FileManager.default

        var tmpDir: URL!
        if #available(OSX 10.12, *) {
            tmpDir = fm.temporaryDirectory
        } else {
            fatalError()
        }

        standfordBunnyObjFile = tmpDir.appendingPathComponent("standfordBunny.obj")

        if !fm.fileExists(atPath: standfordBunnyObjFile.path) {
            let data = try! Data.init(contentsOf: Resources.stanfordBunnyObj)
            try! data.write(to: standfordBunnyObjFile)
        }

    }

    override func tearDown() {
        super.tearDown()
    }

    func testFailingInitializer() {
        XCTAssertThrowsError(try AiScene(file: "<no useful path>"))
    }

    func testLoadAiSceneObj() {
        var scene: AiScene!
        XCTAssertNoThrow(scene = try AiScene(file: standfordBunnyObjFile.path))
        XCTAssertEqual(scene.numMeshes, 1)

        XCTAssertEqual(scene.meshes[0].name, "defaultobject") // assimp default naming
    }

}
