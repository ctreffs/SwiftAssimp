import XCTest
import Assimp
import CAssimp

final class AssimpTests: XCTestCase {

    static var allTests = [
        ("testFailingInitializer", testFailingInitializer)
    ]

    func testFailingInitializer() {
        XCTAssertThrowsError(try AiScene(file: "<no useful path>"))
    }

    func testLoadAiSceneDAE() {

        let fileURL = try! Resource.load(.duck_dae)

        var scene: AiScene!
        XCTAssertNoThrow(scene = try AiScene(file: fileURL.path))
        XCTAssertEqual(scene.numMeshes, 1)
        XCTAssertEqual(scene.numTextures, 0)
        XCTAssertEqual(scene.numMaterials, 1)
        XCTAssertEqual(scene.numLights, 1)

        XCTAssertEqual(scene.meshes[0].name, "LOD3spShape")
        XCTAssertEqual(scene.meshes[0].numVertices, 8500)
        XCTAssertEqual(scene.meshes[0].numFaces, 2144)

        XCTAssertEqual(scene.lights[0].name, "directionalLight1")
    }

    func testLoadAiSceneObj() {

        let fileURL = try! Resource.load(.box_obj)

        var scene: AiScene!
        XCTAssertNoThrow(scene = try AiScene(file: fileURL.path))
        XCTAssertEqual(scene.numMeshes, 1)
        XCTAssertEqual(scene.numTextures, 0)
        XCTAssertEqual(scene.numMaterials, 2)
        XCTAssertEqual(scene.numLights, 0)

        XCTAssertEqual(scene.meshes[0].name, "1")
        XCTAssertEqual(scene.meshes[0].numVertices, 8 * 3)
        XCTAssertEqual(scene.meshes[0].numFaces, 6)

    }

}
