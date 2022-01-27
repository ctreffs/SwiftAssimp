//
// AiLight.swift
// SwiftAssimp
//
// Copyright © 2019-2022 Christian Treffs. All rights reserved.
// Licensed under BSD 3-Clause License. See LICENSE file for details.

@_implementationOnly import CAssimp

public struct AiLight {
    let light: aiLight

    init(_ aiLight: aiLight) {
        light = aiLight
    }

    init?(_ aiLight: aiLight?) {
        guard let aiLight = aiLight else {
            return nil
        }
        self.init(aiLight)
    }

    /// The name of the light source.
    ///
    /// There must be a node in the scene-graph with the same name.
    /// This node specifies the position of the light in the scene
    /// hierarchy and can be animated.
    public lazy var name: String? = String(light.mName)

    /// The type of the light source.
    public lazy var type = AiLightSourceType(light.mType)

    /// Position of the light source in space. Relative to the
    /// transformation of the node corresponding to the light.
    ///
    /// The position is undefined for directional lights.
    public lazy var position = Vec3(light.mPosition)

    /// Direction of the light source in space. Relative to the
    /// transformation of the node corresponding to the light.
    ///
    /// The direction is undefined for point lights. The vector
    /// may be normalized, but it needn't.
    public lazy var direction = Vec3(light.mDirection)

    /// Up direction of the light source in space. Relative to the
    /// transformation of the node corresponding to the light.
    ///
    /// The direction is undefined for point lights. The vector
    /// may be normalized, but it needn't.
    public lazy var up = Vec3(light.mUp)

    /// Constant light attenuation factor.
    ///
    /// The intensity of the light source at a given distance 'd' from
    /// the light's position is
    /// @code
    /// Atten = 1/( att0 + att1 * d + att2 * d*d)
    /// @endcode
    /// This member corresponds to the att0 variable in the equation.
    /// Naturally undefined for directional lights.
    public lazy var attenuationConstant: Float = light.mAttenuationConstant

    /// Linear light attenuation factor.
    ///
    /// The intensity of the light source at a given distance 'd' from
    /// the light's position is
    /// @code
    /// Atten = 1/( att0 + att1 * d + att2 * d*d)
    /// @endcode
    /// This member corresponds to the att1 variable in the equation.
    /// Naturally undefined for directional lights.
    public lazy var attenuationLinear: Float = light.mAttenuationLinear

    /// Quadratic light attenuation factor.
    ///
    /// The intensity of the light source at a given distance 'd' from
    /// the light's position is
    /// @code
    /// Atten = 1/( att0 + att1 * d + att2 * d*d)
    /// @endcode
    /// This member corresponds to the att2 variable in the equation.
    /// Naturally undefined for directional lights.
    public lazy var attenuationQuadratic: Float = light.mAttenuationQuadratic

    /// Diffuse color of the light source
    ///
    /// The diffuse light color is multiplied with the diffuse
    /// material color to obtain the final color that contributes
    /// to the diffuse shading term.
    public lazy var colorDiffuse = Vec3(light.mColorDiffuse)

    /// Specular color of the light source
    ///
    /// The specular light color is multiplied with the specular
    /// material color to obtain the final color that contributes
    /// to the specular shading term.
    public lazy var colorSpecular = Vec3(light.mColorSpecular)

    /// Ambient color of the light source
    ///
    /// The ambient light color is multiplied with the ambient
    /// material color to obtain the final color that contributes
    /// to the ambient shading term. Most renderers will ignore
    /// this value it, is just a remaining of the fixed-function pipeline
    /// that is still supported by quite many file formats.
    public lazy var colorAmbient = Vec3(light.mColorAmbient)

    /// Inner angle of a spot light's light cone.
    ///
    /// The spot light has maximum influence on objects inside this
    /// angle. The angle is given in radians. It is 2PI for point
    /// lights and undefined for directional lights.
    public lazy var angleInnerCone: Float = light.mAngleInnerCone

    /// Outer angle of a spot light's light cone.
    ///
    /// The spot light does not affect objects outside this angle.
    /// The angle is given in radians. It is 2PI for point lights and
    /// undefined for directional lights. The outer angle must be
    /// greater than or equal to the inner angle.
    /// It is assumed that the application uses a smooth
    /// interpolation between the inner and the outer cone of the
    /// spot light.
    public lazy var angleOuterCone: Float = light.mAngleOuterCone

    /// Size of area light source.
    public lazy var size = Vec2(light.mSize)
}

public enum AiLightSourceType {
    case undefined

    /// A directional light source has a well-defined direction
    /// but is infinitely far away. That's quite a good
    /// approximation for sun light.
    case directional

    /// A point light source has a well-defined position
    /// in space but no direction - it emits light in all
    /// directions. A normal bulb is a point light.
    case point

    /// A spot light source emits light in a specific
    /// angle. It has a position and a direction it is pointing to.
    /// A good example for a spot light is a light spot in
    /// sport arenas.
    case spot

    /// The generic light level of the world, including the bounces
    /// of all other light sources.
    /// Typically, there's at most one ambient light in a scene.
    /// This light type doesn't have a valid position, direction, or
    /// other properties, just a color.
    case ambient

    /// An area light is a rectangle with predefined size that uniformly
    /// emits light from one of its sides. The position is center of the
    /// rectangle and direction is its normal vector.
    case area

    init(_ aiLightSourceType: aiLightSourceType) {
        switch aiLightSourceType {
        case aiLightSource_UNDEFINED:
            self = .undefined

        case aiLightSource_DIRECTIONAL:
            self = .directional

        case aiLightSource_POINT:
            self = .point

        case aiLightSource_SPOT:
            self = .spot

        case aiLightSource_AMBIENT:
            self = .ambient

        case aiLightSource_AREA:
            self = .area

        default:
            self = .undefined
        }
    }
}
