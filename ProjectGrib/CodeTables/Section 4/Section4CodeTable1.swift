//
//  Section4CodeTable1.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section4CodeTable1 {
    case Temperature
    case Moisture
    case Momentum
    case Mass
    case ShortwaveRadiation
    case LongwaveRadiation
    case Cloud
    case ThermodynamicStabilityIndices
    case KinematicStabilityIndices
    case TemperatureProbabilities
    case MoistureProbabilities
    case MomentumProbabilities
    case MassProbabilities
    case Aerosols
    case TraceGases
    case Radar
    case ForecastRadarImagery
    case Electrodynamics
    case NuclearRadiology
    case PhysicalAtmosphericProperties
    case CCITTIA5
    case Miscellaneous
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        switch value {
            case 0: self = .Temperature
            case 1: self = .Moisture
            case 2: self = .Momentum
            case 3: self = .Mass
            case 4: self = .ShortwaveRadiation
            case 5: self = .LongwaveRadiation
            case 6: self = .Cloud
            case 7: self = .ThermodynamicStabilityIndices
            case 8: self = .KinematicStabilityIndices
            case 9: self = .TemperatureProbabilities
            case 10: self = .MoistureProbabilities
            case 11: self = .MomentumProbabilities
            case 12: self = .MassProbabilities
            case 13: self = .Aerosols
            case 14: self = .TraceGases
            case 15: self = .Radar
            case 16: self = .ForecastRadarImagery
            case 17: self = .Electrodynamics
            case 18: self = .NuclearRadiology
            case 19: self = .PhysicalAtmosphericProperties
            case 190: self = .CCITTIA5
            case 191: self = .Miscellaneous
            case 255: self = .Missing
            default: if value >= 192 && value <= 254 { self = .ReservedForLocalUse } else { self = .Reserved }
        }
    }
}
