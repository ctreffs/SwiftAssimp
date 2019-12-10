//
//  AiShadingMode.swift
//
//
//  Created by Christian Treffs on 10.12.19.
//

import CAssimp

public struct AiShadingMode: RawRepresentable {
    public let rawValue: aiShadingMode

    public init(rawValue: UInt32) {
        self.rawValue = aiShadingMode(rawValue: rawValue)
    }

    public init(rawValue: aiShadingMode) {
        self.rawValue = rawValue
    }

    /** Flat shading. Shading is done on per-face base,
     *  diffuse only. Also known as 'faceted shading'.
     */
    public static let flat = AiShadingMode(rawValue: aiShadingMode_Flat)

    /** Simple Gouraud shading.
     */
    public static let gouraud = AiShadingMode(rawValue: aiShadingMode_Gouraud)

    /** Phong-Shading -
     */
    public static let phong = AiShadingMode(rawValue: aiShadingMode_Phong)

    /** Phong-Blinn-Shading
     */
    public static let blinn = AiShadingMode(rawValue: aiShadingMode_Blinn)

    /** Toon-Shading per pixel
     *
     *  Also known as 'comic' shader.
     */
    public static let toon = AiShadingMode(rawValue: aiShadingMode_Toon)

    /** OrenNayar-Shading per pixel
     *
     *  Extension to standard Lambertian shading, taking the
     *  roughness of the material into account
     */
    public static let orenNayar = AiShadingMode(rawValue: aiShadingMode_OrenNayar)

    /** Minnaert-Shading per pixel
     *
     *  Extension to standard Lambertian shading, taking the
     *  "darkness" of the material into account
     */
    public static let minnaert = AiShadingMode(rawValue: aiShadingMode_Minnaert)

    /** CookTorrance-Shading per pixel
     *
     *  Special shader for metallic surfaces.
     */
    public static let cookTorrance = AiShadingMode(rawValue: aiShadingMode_CookTorrance)

    /** No shading at all. Constant light influence of 1.0.
     */
    public static let noShading = AiShadingMode(rawValue: aiShadingMode_NoShading)

    /** Fresnel shading
     */
    public static let fresnel = AiShadingMode(rawValue: aiShadingMode_Fresnel)
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
