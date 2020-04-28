import XCTest
import Assimp
import CAssimp

final class AssimpTests: XCTestCase {

    func testVersion() {
        XCTAssertEqual(aiGetVersionMajor(), 5)
        XCTAssertNotNil(aiGetVersionMinor())
        XCTAssertNotNil(aiGetVersionRevision())
    }

    func testFailingInitializer() {
        XCTAssertThrowsError(try AiScene(file: "<no useful path>"))
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

    func testLoadAiSceneDAE() throws {

        let fileURL = try Resource.load(.duck_dae)

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

        // Mesh

        XCTAssertEqual(scene.meshes[0].name, "LOD3spShape")
        XCTAssertEqual(scene.meshes[0].primitiveTypes, [.triangle, .polygon])
        XCTAssertEqual(scene.meshes[0].numVertices, 8500)
        XCTAssertEqual(scene.meshes[0].vertices[0...2], [-23.9364, 11.5353, 30.6125])
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

    func testLoadAiSceneObj() throws {

        let fileURL = try Resource.load(.box_obj)

        let scene: AiScene = try AiScene(file: fileURL.path)

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

        // Mesh

        XCTAssertEqual(scene.meshes[0].name, "1")
        XCTAssertEqual(scene.meshes[0].primitiveTypes, [.polygon])
        XCTAssertEqual(scene.meshes[0].numVertices, 8 * 3)
        XCTAssertEqual(scene.meshes[0].vertices[0...2], [-0.5, 0.5, 0.5])
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

        // Textures

        XCTAssertEqual(scene.textures.count, 0)
        XCTAssertEqual(scene.meshes[0].numUVComponents, [])
        XCTAssertEqual(scene.meshes[0].textureCoords.count, 0)

        // Lights

        XCTAssertEqual(scene.lights.count, 0)

        // Cameras

        XCTAssertEqual(scene.cameras.count, 0)
    }

    func testLoadAiScene3DS() throws {
        let fileURL = try Resource.load(.cubeDiffuseTextured_3ds)

        let scene: AiScene = try AiScene(file: fileURL.path)

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

        // Mesh

        XCTAssertEqual(scene.meshes[0].name, "0")
        XCTAssertEqual(scene.meshes[0].primitiveTypes, [.triangle])
        XCTAssertEqual(scene.meshes[0].numVertices, 36)
        XCTAssertEqual(scene.meshes[0].vertices[0...2], [-25.0, -25.0, 0.0])
        XCTAssertEqual(scene.meshes[0].numFaces, 12)
        XCTAssertEqual(scene.meshes[0].numBones, 0)
        XCTAssertEqual(scene.meshes[0].numAnimMeshes, 0)
        XCTAssertEqual(scene.meshes[0].rawVertices![0], -25.0)
        XCTAssertEqual(scene.meshes[0].rawVertices![1], -25.0)
        XCTAssertEqual(scene.meshes[0].rawVertices![2], 0.0)
        
        XCTAssertEqual(scene.meshes[0].rawVertices![105], -25.0)
        XCTAssertEqual(scene.meshes[0].rawVertices![106], 25.0)
        XCTAssertEqual(scene.meshes[0].rawVertices![107], 0.0)

        // Faces

        XCTAssertEqual(scene.meshes[0].numFaces, 12)
        XCTAssertEqual(scene.meshes[0].faces.count, 12)
        XCTAssertEqual(scene.meshes[0].faces[0].numIndices, 3)
        XCTAssertEqual(scene.meshes[0].faces[0].indices, [0, 1, 2])

        // Materials

        XCTAssertEqual(scene.materials[0].numProperties, 13)
        XCTAssertEqual(scene.materials[0].numAllocated, 20)
        XCTAssertEqual(scene.materials[0].properties[0].key, "?mat.name")

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

    func testPBR() throws {
        //let file = "/Users/treffs/Development/personal/game-dev/fireblade/assets/models/pbr_helmet/pbr_helmet.obj"
        let file = "/Users/treffs/Development/personal/game-dev/fireblade/assets/models/buster_drone/scene.gltf"
        //let file = "/Users/treffs/Development/personal/game-dev/fireblade/assets/models/sponza_pbr/Sponza.gltf"

        // https://threejs.org/docs/#api/en/materials/MeshStandardMaterial
        // http://assimp.sourceforge.net/lib_html/materials.html

        let scene = try AiScene(file: file)

        let textureFiles = scene.materials
            .map { $0.typedProperties }
            .flatMap { $0 }
            .filter { $0.semantic != .none && $0.type == .string && $0.key.contains("file") }
            .compactMap { $0 as? AiMaterialPropertyString }

        print(scene.materials.flatMap { $0.typedProperties })
        
        print(scene.materials.map { $0.shadingModel })

        print(scene.materials.map { $0.getMaterialTextureCount(texType: .diffuse) })
        print(scene.materials.map { $0.getMaterialTextureCount(texType: .metalness) })
        print(scene.materials.map { $0.getMaterialString(.NAME) })

        print(scene.materials.map { $0.getMaterialColor(.COLOR_DIFFUSE) })
        print(scene.materials.map { $0.getMaterialFloatArray(.UVTRANSFORM(.diffuse, 0)) })

        print(scene.materials.compactMap { $0.getMaterialProperty(.GLTF_PBRMETALLICROUGHNESS_BASE_COLOR_TEXTURE)?.string })
        print(scene.materials.compactMap { $0.getMaterialProperty(.GLTF_PBRMETALLICROUGHNESS_METALLICROUGHNESS_TEXTURE)?.string })

        print(scene.materials.compactMap { $0.getMaterialTexture(texType: .diffuse, texIndex: 0) })

        XCTFail("not implemented yet")
    }

}
