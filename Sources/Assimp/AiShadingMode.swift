//
//  AiShadingMode.swift
//
//
//  Created by Christian Treffs on 10.12.19.
//

@_implementationOnly import CAssimp

public struct AiShadingMode: RawRepresentable {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    init(_ shadingMode: aiShadingMode) {
        self.rawValue = shadingMode.rawValue
    }

    /** Flat shading. Shading is done on per-face base,
     *  diffuse only. Also known as 'faceted shading'.
     */
    public static let flat = AiShadingMode(aiShadingMode_Flat)

    /** Simple Gouraud shading.
     */
    public static let gouraud = AiShadingMode(aiShadingMode_Gouraud)

    /** Phong-Shading -
     */
    public static let phong = AiShadingMode(aiShadingMode_Phong)

    /** Phong-Blinn-Shading
     */
    public static let blinn = AiShadingMode(aiShadingMode_Blinn)

    /** Toon-Shading per pixel
     *
     *  Also known as 'comic' shader.
     */
    public static let toon = AiShadingMode(aiShadingMode_Toon)

    /** OrenNayar-Shading per pixel
     *
     *  Extension to standard Lambertian shading, taking the
     *  roughness of the material into account
     */
    public static let orenNayar = AiShadingMode(aiShadingMode_OrenNayar)

    /** Minnaert-Shading per pixel
     *
     *  Extension to standard Lambertian shading, taking the
     *  "darkness" of the material into account
     */
    public static let minnaert = AiShadingMode(aiShadingMode_Minnaert)

    /** CookTorrance-Shading per pixel
     *
     *  Special shader for metallic surfaces.
     */
    public static let cookTorrance = AiShadingMode(aiShadingMode_CookTorrance)

    /** No shading at all. Constant light influence of 1.0.
     */
    public static let noShading = AiShadingMode(aiShadingMode_NoShading)

    /** Fresnel shading
     */
    public static let fresnel = AiShadingMode(aiShadingMode_Fresnel)
}

extension AiShadingMode: Equatable { }
extension AiShadingMode: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .flat:
            return "flat"
        case .blinn:
            return "blinn"
        case .cookTorrance:
            return "cookTorrance"
        case .fresnel:
            return "fresnel"
        case .gouraud:
            return "gouraud"
        case .minnaert:
            return "minnaert"
        case .noShading:
            return "noShading"
        case .orenNayar:
            return "orenNayar"
        case .phong:
            return "phong"
        case .toon:
            return "toon"
        default:
            return "AiShadingMode<Unknown>(\(self.rawValue))"
        }
    }
}
