//
// AiCamera.swift
// SwiftAssimp
//
// Copyright © 2019-2023 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

public struct AiCamera {
    init(_ camera: aiCamera) {
        name = String(camera.mName)
        position = Vec3(camera.mPosition)
        up = Vec3(camera.mUp)
        lookAt = Vec3(camera.mLookAt)
        horizontalFOV = camera.mHorizontalFOV
        clipPlaneNear = camera.mClipPlaneNear
        clipPlaneFar = camera.mClipPlaneFar
        aspect = camera.mAspect
        orthographicWidth = camera.mOrthographicWidth
    }

    init?(_ camera: aiCamera?) {
        guard let camera = camera else {
            return nil
        }

        self.init(camera)
    }

    /// The name of the camera.
    ///
    /// There must be a node in the scenegraph with the same name.
    /// This node specifies the position of the camera in the scene
    /// hierarchy and can be animated.
    public var name: String?

    /// Position of the camera relative to the coordinate space
    /// defined by the corresponding node.
    ///
    /// The default value is 0|0|0.
    public var position: Vec3

    /// 'Up' - vector of the camera coordinate system relative to
    /// the coordinate space defined by the corresponding node.
    ///
    /// The 'right' vector of the camera coordinate system is
    /// the cross product of  the up and lookAt vectors.
    /// The default value is 0|1|0. The vector
    /// may be normalized, but it needn't.
    public var up: Vec3

    /// 'LookAt' - vector of the camera coordinate system relative to
    /// the coordinate space defined by the corresponding node.
    ///
    /// This is the viewing direction of the user.
    /// The default value is 0|0|1. The vector
    /// may be normalized, but it needn't.
    public var lookAt: Vec3

    /// Horizontal field of view angle, in radians.
    ///
    /// The field of view angle is the angle between the center
    /// line of the screen and the left or right border.
    /// The default value is 1/4PI.
    public var horizontalFOV: Float

    /// Distance of the near clipping plane from the camera.
    ///
    /// The value may not be 0.f (for arithmetic reasons to prevent
    /// a division through zero). The default value is 0.1f.
    public var clipPlaneNear: Float

    /// Distance of the far clipping plane from the camera.
    ///
    /// The far clipping plane must, of course, be further away than the
    /// near clipping plane. The default value is 1000.f. The ratio
    /// between the near and the far plane should not be too
    /// large (between 1000-10000 should be ok) to avoid floating-point
    /// inaccuracies which could lead to z-fighting.
    public var clipPlaneFar: Float

    /// Screen aspect ratio.
    ///
    /// This is the ration between the width and the height of the
    /// screen. Typical values are 4/3, 1/2 or 1/1. This value is
    /// 0 if the aspect ratio is not defined in the source file.
    /// 0 is also the default value.
    public var aspect: Float

    /// Half horizontal orthographic width, in scene units.
    ///
    /// The orthographic width specifies the half width of the
    /// orthographic view box. If non-zero the camera is
    /// orthographic and the mAspect should define to the
    /// ratio between the orthographic width and height
    /// and mHorizontalFOV should be set to 0.
    /// The default value is 0 (not orthographic).
    public var orthographicWidth: Float
}
