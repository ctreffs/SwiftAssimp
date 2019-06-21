//
//  AiPostProcessStep.swift
//  
//
//  Created by Christian Treffs on 21.06.19.
//

import CAssimp

public struct AiPostProcessStep: OptionSet {
    public var rawValue: UInt32

    public static let CalcTangentSpace = AiPostProcessStep(rawValue: aiProcess_CalcTangentSpace.rawValue)
    public static let Debone = AiPostProcessStep(rawValue: aiProcess_Debone.rawValue)
    public static let FindDegenerates = AiPostProcessStep(rawValue: aiProcess_FindDegenerates.rawValue)
    public static let FindInstances = AiPostProcessStep(rawValue: aiProcess_FindInstances.rawValue)
    public static let FindInvalidData = AiPostProcessStep(rawValue: aiProcess_FindInvalidData.rawValue)
    public static let FixInfacingNormals = AiPostProcessStep(rawValue: aiProcess_FixInfacingNormals.rawValue)
    public static let FlipUVs = AiPostProcessStep(rawValue: aiProcess_FlipUVs.rawValue)
    public static let FlipWindingOrder = AiPostProcessStep(rawValue: aiProcess_FlipWindingOrder.rawValue)
    public static let GenNormals = AiPostProcessStep(rawValue: aiProcess_GenNormals.rawValue)
    public static let GenSmoothNormals = AiPostProcessStep(rawValue: aiProcess_GenSmoothNormals.rawValue)
    public static let GenUVCoords = AiPostProcessStep(rawValue: aiProcess_GenUVCoords.rawValue)
    public static let GlobalScale = AiPostProcessStep(rawValue: aiProcess_GlobalScale.rawValue)
    public static let ImproveCacheLocality = AiPostProcessStep(rawValue: aiProcess_ImproveCacheLocality.rawValue)
    public static let JoinIdenticalVertices = AiPostProcessStep(rawValue: aiProcess_JoinIdenticalVertices.rawValue)
    public static let LimitBoneWeights = AiPostProcessStep(rawValue: aiProcess_LimitBoneWeights.rawValue)
    public static let MakeLeftHanded = AiPostProcessStep(rawValue: aiProcess_MakeLeftHanded.rawValue)
    public static let OptimizeGraph = AiPostProcessStep(rawValue: aiProcess_OptimizeGraph.rawValue)
    public static let OptimizeMeshes = AiPostProcessStep(rawValue: aiProcess_OptimizeMeshes.rawValue)
    public static let PreTransformVertices = AiPostProcessStep(rawValue: aiProcess_PreTransformVertices.rawValue)
    public static let RemoveComponent = AiPostProcessStep(rawValue: aiProcess_RemoveComponent.rawValue)
    public static let RemoveRedundantMaterials = AiPostProcessStep(rawValue: aiProcess_RemoveRedundantMaterials.rawValue)
    public static let SortByPType = AiPostProcessStep(rawValue: aiProcess_SortByPType.rawValue)
    public static let SplitByBoneCount = AiPostProcessStep(rawValue: aiProcess_SplitByBoneCount.rawValue)
    public static let SplitLargeMeshes = AiPostProcessStep(rawValue: aiProcess_SplitLargeMeshes.rawValue)
    public static let TransformUVCoords = AiPostProcessStep(rawValue: aiProcess_TransformUVCoords.rawValue)
    public static let Triangulate = AiPostProcessStep(rawValue: aiProcess_Triangulate.rawValue)
    public static let ValidateDataStructure = AiPostProcessStep(rawValue: aiProcess_ValidateDataStructure.rawValue)

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}
