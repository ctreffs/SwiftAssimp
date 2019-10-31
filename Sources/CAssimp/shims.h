#include <assimp/cimport.h>
#include <assimp/cexport.h>
#include <assimp/cfileio.h>
#include <assimp/config.h>
#include <assimp/types.h>
#include <assimp/postprocess.h>
#include <assimp/scene.h>
#include <assimp/light.h>
#include <assimp/material.h>
#include <assimp/ai_assert.h>
#include <assimp/anim.h>
#include <assimp/camera.h>
#include <assimp/color4.h>
#include <assimp/defs.h>
#include <assimp/importerdesc.h>
#include <assimp/matrix3x3.h>
#include <assimp/matrix4x4.h>
#include <assimp/mesh.h>
#include <assimp/metadata.h>
#include <assimp/quaternion.h>
#include <assimp/texture.h>
#include <assimp/vector2.h>
#include <assimp/vector3.h>
#include <assimp/version.h>


// #ifdef __APPLE__
// 	#ifdef __IPHONEOS__
// 		// TODO:
// 	#else
// 		#include "apple_macOS.h"
// 	#endif
// #else
// 	#include "linux.h"
// #endif
// 