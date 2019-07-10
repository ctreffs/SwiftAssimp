import XCTest
import Assimp
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
        XCTAssertNoThrow(scene = try AiScene(file: fileURL.path, flags: [.removeRedundantMaterials,
                                                                         .genSmoothNormals]))

        XCTAssertEqual(scene.flags, [])
        XCTAssertEqual(scene.numMeshes, 1)
        XCTAssertEqual(scene.numMaterials, 1)
        XCTAssertEqual(scene.numAnimations, 0)
        XCTAssertEqual(scene.numCameras, 1)
        XCTAssertEqual(scene.numLights, 1)
        XCTAssertEqual(scene.numTextures, 0)

        // Scene Graph

        XCTAssertEqual(scene.rootNode.numMeshes, 0)
        XCTAssertEqual(scene.rootNode.meshes.count, 0)
        XCTAssertEqual(scene.rootNode.numChildren, 3)
        XCTAssertEqual(scene.rootNode.children.count, 3)
        XCTAssertEqual(scene.rootNode.name, "VisualSceneNode")
        XCTAssertEqual(scene.rootNode.children[0].name, "LOD3sp")
        XCTAssertEqual(scene.rootNode.children[0].meshes, [0])
        XCTAssertEqual(scene.rootNode.children[0].numMeshes, 1)
        XCTAssertEqual(scene.rootNode.children[0].numChildren, 0)
        XCTAssertEqual(scene.rootNode.children[1].name, "camera1")
        XCTAssertEqual(scene.rootNode.children[1].meshes, [])
        XCTAssertEqual(scene.rootNode.children[1].numMeshes, 0)
        XCTAssertEqual(scene.rootNode.children[1].numChildren, 0)
        XCTAssertEqual(scene.rootNode.children[2].name, "directionalLight1")
        XCTAssertEqual(scene.rootNode.children[2].meshes, [])
        XCTAssertEqual(scene.rootNode.children[2].numMeshes, 0)
        XCTAssertEqual(scene.rootNode.children[2].numChildren, 0)

        print(scene.rootNode)

        // Mesh

        XCTAssertEqual(scene.meshes[0].name, "LOD3spShape")
        XCTAssertEqual(scene.meshes[0].primitiveTypes, [.triangle, .polygon])
        XCTAssertEqual(scene.meshes[0].numVertices, 8500)
        XCTAssertEqual(scene.meshes[0].vertices[0], [-23.9364, 11.5353, 30.6125])
        XCTAssertEqual(scene.meshes[0].numFaces, 2144)
        XCTAssertEqual(scene.meshes[0].numBones, 0)
        XCTAssertEqual(scene.meshes[0].numAnimMeshes, 0)

        // Faces

        XCTAssertEqual(scene.meshes[0].numFaces, 2144)
        XCTAssertEqual(scene.meshes[0].faces.count, 2144)
        XCTAssertEqual(scene.meshes[0].faces[0].numIndices, 4)
        XCTAssertEqual(scene.meshes[0].faces[0].indices, [0, 1, 2, 3])

        // Materials

        XCTAssertEqual(scene.materials[0].numProperties, 19)
        XCTAssertEqual(scene.materials[0].numAllocated, 20)
        XCTAssertEqual(scene.materials[0].properties[0].key, "?mat.name")

        scene.materials[0].typedProperties.map { print($0) }

        // Textures

        XCTAssertEqual(scene.textures.count, 0)
        XCTAssertEqual(scene.meshes[0].numUVComponents, [2])
        XCTAssertEqual(scene.meshes[0].textureCoords.count, 1)
        XCTAssertEqual(scene.meshes[0].textureCoords[0].count, 8500)
        XCTAssertEqual(scene.meshes[0].textureCoords[0][0], [0.866606, 0.398924, 0.0])

        // Lights

        XCTAssertEqual(scene.lights[0].name, "directionalLight1")

        // Cameras

        XCTAssertEqual(scene.cameras.count, 1)

    }

    func testLoadAiSceneObj() {

        let fileURL = try! Resource.load(.box_obj)

        let scene: AiScene = try! AiScene(file: fileURL.path)

        XCTAssertEqual(scene.flags, [])
        XCTAssertEqual(scene.numMeshes, 1)
        XCTAssertEqual(scene.numMaterials, 2)
        XCTAssertEqual(scene.numAnimations, 0)
        XCTAssertEqual(scene.numCameras, 0)
        XCTAssertEqual(scene.numLights, 0)
        XCTAssertEqual(scene.numTextures, 0)

        // Scene Graph

        XCTAssertEqual(scene.rootNode.numMeshes, 0)
        XCTAssertEqual(scene.rootNode.meshes.count, 0)
        XCTAssertEqual(scene.rootNode.numChildren, 1)
        XCTAssertEqual(scene.rootNode.children.count, 1)
        XCTAssertEqual(scene.rootNode.name, "models_OBJ_box.obj.box.obj")
        XCTAssertEqual(scene.rootNode.children[0].name, "1")
        XCTAssertEqual(scene.rootNode.children[0].meshes, [0])
        XCTAssertEqual(scene.rootNode.children[0].numMeshes, 1)
        XCTAssertEqual(scene.rootNode.children[0].numChildren, 0)

        print(scene.rootNode)

        // Mesh

        XCTAssertEqual(scene.meshes[0].name, "1")
        XCTAssertEqual(scene.meshes[0].primitiveTypes, [.polygon])
        XCTAssertEqual(scene.meshes[0].numVertices, 8 * 3)
        XCTAssertEqual(scene.meshes[0].vertices[0], [-0.5, 0.5, 0.5])
        XCTAssertEqual(scene.meshes[0].numFaces, 6)
        XCTAssertEqual(scene.meshes[0].numBones, 0)
        XCTAssertEqual(scene.meshes[0].numAnimMeshes, 0)

        // Faces

        XCTAssertEqual(scene.meshes[0].numFaces, 6)
        XCTAssertEqual(scene.meshes[0].faces.count, 6)
        XCTAssertEqual(scene.meshes[0].faces[0].numIndices, 4)
        XCTAssertEqual(scene.meshes[0].faces[0].indices, [0, 1, 2, 3])

        // Materials

        XCTAssertEqual(scene.materials[0].numProperties, 10)
        XCTAssertEqual(scene.materials[0].numAllocated, 10)
        XCTAssertEqual(scene.materials[0].properties[0].key, "?mat.name")

        scene.materials[0].typedProperties.map { print($0) }

        // Textures

        XCTAssertEqual(scene.textures.count, 0)
        XCTAssertEqual(scene.meshes[0].numUVComponents, [])
        XCTAssertEqual(scene.meshes[0].textureCoords.count, 0)

        // Lights

        XCTAssertEqual(scene.lights.count, 0)

        // Cameras

        XCTAssertEqual(scene.cameras.count, 0)
    }

    func testLoadAiScene3DS() {
        let fileURL = try! Resource.load(.cubeDiffuseTextured_3ds)

        let scene: AiScene = try! AiScene(file: fileURL.path)

        XCTAssertEqual(scene.flags, [])
        XCTAssertEqual(scene.numMeshes, 1)
        XCTAssertEqual(scene.numMaterials, 1)
        XCTAssertEqual(scene.numAnimations, 0)
        XCTAssertEqual(scene.numCameras, 0)
        XCTAssertEqual(scene.numLights, 0)
        XCTAssertEqual(scene.numTextures, 0)

        // Scene Graph

        XCTAssertEqual(scene.rootNode.numMeshes, 0)
        XCTAssertEqual(scene.rootNode.meshes.count, 0)
        XCTAssertEqual(scene.rootNode.numChildren, 1)
        XCTAssertEqual(scene.rootNode.children.count, 1)
        XCTAssertEqual(scene.rootNode.name, "<3DSRoot>")
        XCTAssertEqual(scene.rootNode.children[0].name, "Quader01")
        XCTAssertEqual(scene.rootNode.children[0].meshes, [0])
        XCTAssertEqual(scene.rootNode.children[0].numMeshes, 1)
        XCTAssertEqual(scene.rootNode.children[0].numChildren, 0)

        print(scene.rootNode)

        // Mesh

        XCTAssertEqual(scene.meshes[0].name, "0")
        XCTAssertEqual(scene.meshes[0].primitiveTypes, [.triangle])
        XCTAssertEqual(scene.meshes[0].numVertices, 36)
        XCTAssertEqual(scene.meshes[0].vertices[0], [-25.0, -25.0, 0.0])
        XCTAssertEqual(scene.meshes[0].numFaces, 12)
        XCTAssertEqual(scene.meshes[0].numBones, 0)
        XCTAssertEqual(scene.meshes[0].numAnimMeshes, 0)

        // Faces

        XCTAssertEqual(scene.meshes[0].numFaces, 12)
        XCTAssertEqual(scene.meshes[0].faces.count, 12)
        XCTAssertEqual(scene.meshes[0].faces[0].numIndices, 3)
        XCTAssertEqual(scene.meshes[0].faces[0].indices, [0, 1, 2])

        // Materials

        XCTAssertEqual(scene.materials[0].numProperties, 13)
        XCTAssertEqual(scene.materials[0].numAllocated, 20)
        XCTAssertEqual(scene.materials[0].properties[0].key, "?mat.name")

        scene.materials[0].typedProperties.map { print($0) }

        // Textures

        XCTAssertEqual(scene.textures.count, 0)
        XCTAssertEqual(scene.meshes[0].numUVComponents, [2])
        XCTAssertEqual(scene.meshes[0].textureCoords.count, 1)
        XCTAssertEqual(scene.meshes[0].textureCoords[0].count, 36)
        XCTAssertEqual(scene.meshes[0].textureCoords[0][0], [0.6936096, 0.30822724, 0.0])

        // Lights

        XCTAssertEqual(scene.lights.count, 0)

        // Cameras

        XCTAssertEqual(scene.cameras.count, 0)

    }

}
