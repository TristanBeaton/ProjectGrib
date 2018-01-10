//
//  Section4CodeTable5.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section4CodeTable5 {
    case GroundOrWaterSurface
    case CloudBaseLevel
    case LevelOfCloudTops
    case LevelOf0CIsotherm
    case LevelOfAdiabaticCondensationLiftedFromTheSurface
    case MaximumWindLevel
    case Tropopause
    case NominalTopOfTheAtmosphere
    case SeaBottom
    case EntireAtmosphere
    case CumulonimbusBase
    case CumulonimbusTop
    case IsothermalLevel
    case IsobaricSurface
    case MeanSeaLevel
    case SpecificAltitudeAboveMeanSeaLevel
    case SpecifiedHeightLevelAboveGround
    case SigmaLevel
    case HybridLevel
    case DepthBelowLandSurface
    case IsentropicLevel
    case LevelAtSpecifiedPressureDifferenceFromGroundToLevel
    case PotentialVorticitySurface
    case EtaLevel
    case LogarithmicHybridLevel
    case SnowLevel
    case MixedLayerDepth
    case HybridHeightLevel
    case HybridPressureLevel
    case GeneralizedVerticalHeightCoordinate
    case DepthBelowSeaLevel
    case DepthBelowWaterSurface
    case LakeOrRiverBottom
    case BottomOfSedimentLayer
    case BottomOfThermallyActiveSedimentLayer
    case BottomOfSedimentLayerPenetratedByThermalWave
    case MixingLayer
    case BottomOfRootZone
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        switch value {
            case 1: self = .GroundOrWaterSurface
            case 2: self = .CloudBaseLevel
            case 3: self = .LevelOfCloudTops
            case 4: self = .LevelOf0CIsotherm
            case 5: self = .LevelOfAdiabaticCondensationLiftedFromTheSurface
            case 6: self = .MaximumWindLevel
            case 7: self = .Tropopause
            case 8: self = .NominalTopOfTheAtmosphere
            case 9: self = .SeaBottom
            case 10: self = .EntireAtmosphere
            case 11: self = .CumulonimbusBase
            case 12: self = .CumulonimbusTop
            case 20: self = .IsothermalLevel
            case 100: self = .IsobaricSurface
            case 101: self = .MeanSeaLevel
            case 102: self = .SpecificAltitudeAboveMeanSeaLevel
            case 103: self = .SpecifiedHeightLevelAboveGround
            case 104: self = .SigmaLevel
            case 105: self = .HybridLevel
            case 106: self = .DepthBelowLandSurface
            case 107: self = .IsentropicLevel
            case 108: self = .LevelAtSpecifiedPressureDifferenceFromGroundToLevel
            case 109: self = .PotentialVorticitySurface
            case 111: self = .EtaLevel
            case 113: self = .LogarithmicHybridLevel
            case 114: self = .SnowLevel
            case 117: self = .MixedLayerDepth
            case 118: self = .HybridHeightLevel
            case 119: self = .HybridPressureLevel
            case 150: self = .GeneralizedVerticalHeightCoordinate
            case 160: self = .DepthBelowSeaLevel
            case 161: self = .DepthBelowWaterSurface
            case 162: self = .LakeOrRiverBottom
            case 163: self = .BottomOfSedimentLayer
            case 164: self = .BottomOfThermallyActiveSedimentLayer
            case 165: self = .BottomOfSedimentLayerPenetratedByThermalWave
            case 166: self = .MixingLayer
            case 167: self = .BottomOfRootZone
            case 255: self = .Missing
            default: if value >= 192 && value <= 254 { self = .ReservedForLocalUse } else { self = .Reserved }
        }
    }
}
