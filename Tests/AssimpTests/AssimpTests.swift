import XCTest
@testable import Assimp
import CAssimp
import FirebladeMath

final class AssimpTests: XCTestCase {

    static var allTests = [
        ("testFailingInitializer", testFailingInitializer)
    ]

    func testFailingInitializer() {
        XCTAssertThrowsError(try AiScene(file: "<no useful path>"))
    }

    func testVec3fFromAiVector3D() {
        let vec3f = aiVector3D(x: 1.2, y: 3.4, z: 5.6).vector
        XCTAssertEqual(vec3f, Vec3f(1.2, 3.4, 5.6))
        XCTAssertEqual(Vec3f(aiVector3D(x: 5.6, y: 3.4, z: 1.2)), Vec3f(5.6, 3.4, 1.2))
    }

    func testVec2fFromAiVector2D() {
        let vec2f = aiVector2D(x: 1.2, y: 3.4).vector
        XCTAssertEqual(vec2f, Vec2f(1.2, 3.4))
        XCTAssertEqual(Vec2f(aiVector2D(x: 5.6, y: 3.4)), Vec2f(5.6, 3.4))
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
        XCTAssertEqual(scene.meshes[0].numUVComponents, [2])
        XCTAssertEqual(scene.meshes[0].textureCoords.count, 1)
        XCTAssertEqual(scene.meshes[0].textureCoords[0].count, 8500)
        print(scene.meshes[0]._mesh)

    }

    func testLoadAiSceneObj() {

        let fileURL = try! Resource.load(.box_obj)

        let scene: AiScene = try! AiScene(file: fileURL.path, flags: [.GenNormals])
        XCTAssertEqual(scene.numMeshes, 1)
        XCTAssertEqual(scene.numTextures, 0)
        XCTAssertEqual(scene.numMaterials, 2)
        XCTAssertEqual(scene.numLights, 0)

        XCTAssertEqual(scene.meshes[0].name, "1")
        XCTAssertEqual(scene.meshes[0].numVertices, 8 * 3)
        XCTAssertEqual(scene.meshes[0].numFaces, 6)

        XCTAssertEqual(scene.meshes[0].normals.count, 8 * 3)
        XCTAssertEqual(scene.meshes[0].normals[0], [-1.0, -0.0, -0.0])

        XCTAssertEqual(scene.meshes[0].numUVComponents, [])
        XCTAssertEqual(scene.meshes[0].textureCoords.count, 0)

        XCTAssertEqual(scene.materials[0].numProperties, 10)
    }

    func testLoadAiSceneObjBig() {
        let fileURL = URL(string: "/Users/treffs/Downloads/rack/RAF2DOSYA.obj")!
        var scene: AiScene!

        XCTAssertNoThrow(scene = try AiScene(file: fileURL.path))

        XCTAssertEqual(scene.numMeshes, 4)
        XCTAssertEqual(scene.numMaterials, 5)

        print(scene.meshes.enumerated().compactMap { ($0, $1.name) })
    }

}
