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
        
        // print(scene.materials.map { $0.debugDescription })
        
        XCTAssertEqual(scene.materials[0].getMaterialColor(.COLOR_DIFFUSE), SIMD4<Float>(1.0, 1.0, 1.0, 1.0))
        XCTAssertEqual(scene.materials[0].getMaterialString(.TEXTURE(.diffuse, 0)), "./duckCM.tga")
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
        
        XCTAssertEqual(scene.materials[0].getMaterialColor(.COLOR_DIFFUSE), SIMD4<Float>(0.5882353, 0.5882353, 0.5882353, 1.0))
        XCTAssertEqual(scene.materials[0].getMaterialString(.TEXTURE(.diffuse, 0)), "TEST.PNG")

    }
    
    func testLoadAiSceneGLB() throws {
        let fileURL = try Resource.load(.damagedHelmet_glb)

        let scene: AiScene = try AiScene(file: fileURL.path)
        
        XCTAssertEqual(scene.flags, [])
        XCTAssertEqual(scene.numMeshes, 1)
        XCTAssertEqual(scene.numMaterials, 2)
        XCTAssertEqual(scene.numAnimations, 0)
        XCTAssertEqual(scene.numCameras, 0)
        XCTAssertEqual(scene.numLights, 0)
        XCTAssertEqual(scene.numTextures, 5)

        // Scene Graph

        XCTAssertEqual(scene.rootNode.numMeshes, 1)
        XCTAssertEqual(scene.rootNode.meshes.count, 1)
        XCTAssertEqual(scene.rootNode.numChildren, 0)
        XCTAssertEqual(scene.rootNode.children.count, 0)
        XCTAssertEqual(scene.rootNode.name, "node_damagedHelmet_-6514")
        // Mesh

        XCTAssertEqual(scene.meshes[0].name, "mesh_helmet_LP_13930damagedHelmet")
        XCTAssertEqual(scene.meshes[0].primitiveTypes, [.triangle])
        XCTAssertEqual(scene.meshes[0].numVertices, 14556)
        XCTAssertEqual(scene.meshes[0].vertices[0...2], [-0.61199456, -0.030940875, 0.48309004])
        XCTAssertEqual(scene.meshes[0].numFaces, 15452)
        XCTAssertEqual(scene.meshes[0].numBones, 0)
        XCTAssertEqual(scene.meshes[0].numAnimMeshes, 0)
        XCTAssertEqual(scene.meshes[0].rawVertices![0], -0.61199456)
        XCTAssertEqual(scene.meshes[0].rawVertices![1], -0.030940875)
        XCTAssertEqual(scene.meshes[0].rawVertices![2], 0.48309004)
        
        XCTAssertEqual(scene.meshes[0].rawVertices![105], -0.5812146)
        XCTAssertEqual(scene.meshes[0].rawVertices![106], -0.029344887)
        XCTAssertEqual(scene.meshes[0].rawVertices![107], 0.391574)

        // Faces

        XCTAssertEqual(scene.meshes[0].numFaces, 15452)
        XCTAssertEqual(scene.meshes[0].faces.count, 15452)
        XCTAssertEqual(scene.meshes[0].faces[0].numIndices, 3)
        XCTAssertEqual(scene.meshes[0].faces[0].indices, [0, 1, 2])

        // Materials

        XCTAssertEqual(scene.materials[0].numProperties, 48)
        XCTAssertEqual(scene.materials[0].numAllocated, 80)
        XCTAssertEqual(scene.materials[0].properties[0].key, "?mat.name")

        // Textures

        XCTAssertEqual(scene.textures.count, scene.numTextures)
        XCTAssertEqual(scene.meshes[0].numUVComponents, [2])
        XCTAssertEqual(scene.meshes[0].textureCoords.count, 1)
        XCTAssertEqual(scene.meshes[0].textureCoords[0].count, 14556)
        XCTAssertEqual(scene.meshes[0].textureCoords[0][0], [0.704686, -0.24560404, 0.0])
        
        XCTAssertEqual(scene.textures[0].filename, nil)
        XCTAssertEqual(scene.textures[0].achFormatHint, "jpg")
        XCTAssertEqual(scene.textures[0].width, 935629)
        XCTAssertEqual(scene.textures[0].height, 0)
        XCTAssertEqual(scene.textures[0].isCompressed, true)
        XCTAssertEqual(scene.textures[0].numPixels, 233907)
        XCTAssertEqual(scene.textures[0].pcData.count, 233907)
        XCTAssertEqual(scene.textures[0].pcDataBGRA.count, 935628)
        XCTAssertEqual(scene.textures[0].pcDataRGBA.count, 935628)
        
        XCTAssertEqual(scene.textures[0].pcData[0].a, 224)
        XCTAssertEqual(scene.textures[0].pcData[0].r, 255)
        XCTAssertEqual(scene.textures[0].pcData[0].g, 216)
        XCTAssertEqual(scene.textures[0].pcData[0].b, 255)
        XCTAssertEqual(scene.textures[0].pcDataBGRA[0], 255) // b 255
        XCTAssertEqual(scene.textures[0].pcDataBGRA[1], 216) // g 216
        XCTAssertEqual(scene.textures[0].pcDataBGRA[2], 255) // r 255
        XCTAssertEqual(scene.textures[0].pcDataBGRA[3], 224) // a 224
        XCTAssertEqual(scene.textures[0].pcDataRGBA[0], 255) // r 255
        XCTAssertEqual(scene.textures[0].pcDataRGBA[1], 216) // g 216
        XCTAssertEqual(scene.textures[0].pcDataRGBA[2], 255) // b 255
        XCTAssertEqual(scene.textures[0].pcDataRGBA[3], 224) // a 224
        
        XCTAssertEqual(scene.textures[1].filename, nil)
        XCTAssertEqual(scene.textures[1].achFormatHint, "jpg")
        XCTAssertEqual(scene.textures[1].width, 1300661)
        XCTAssertEqual(scene.textures[1].height, 0)
        XCTAssertEqual(scene.textures[1].isCompressed, true)
        XCTAssertEqual(scene.textures[1].numPixels, 325165)
        XCTAssertEqual(scene.textures[1].pcData.count, 325165)
        XCTAssertEqual(scene.textures[1].pcDataBGRA.count, 1300660)
        XCTAssertEqual(scene.textures[1].pcDataRGBA.count, 1300660)
        XCTAssertEqual(scene.textures[1].pcData[0].a, 224)
        XCTAssertEqual(scene.textures[1].pcData[0].r, 255)
        XCTAssertEqual(scene.textures[1].pcData[0].g, 216)
        XCTAssertEqual(scene.textures[1].pcData[0].b, 255)
        XCTAssertEqual(scene.textures[1].pcDataBGRA[0], 255) // b 255
        XCTAssertEqual(scene.textures[1].pcDataBGRA[1], 216) // g 216
        XCTAssertEqual(scene.textures[1].pcDataBGRA[2], 255) // r 255
        XCTAssertEqual(scene.textures[1].pcDataBGRA[3], 224) // a 224
        XCTAssertEqual(scene.textures[1].pcDataRGBA[0], 255) // r 255
        XCTAssertEqual(scene.textures[1].pcDataRGBA[1], 216) // g 216
        XCTAssertEqual(scene.textures[1].pcDataRGBA[2], 255) // b 255
        XCTAssertEqual(scene.textures[1].pcDataRGBA[3], 224) // a 224

        // Lights

        XCTAssertEqual(scene.lights.count, 0)

        // Cameras

        XCTAssertEqual(scene.cameras.count, 0)
    }
}
