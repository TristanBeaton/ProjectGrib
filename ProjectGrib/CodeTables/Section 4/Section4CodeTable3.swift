//
//  Section4CodeTable3.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section4CodeTable3 {
    case Analysis
    case Initialization
    case Forecast
    case BiasCorrectedForecast
    case EnsembleForecast
    case ProbabilityForecast
    case ForecastError
    case AnalysisError
    case Observation
    case Climatological
    case ProbabilityWeightedForecast
    case BiasCorrectedEnsembleForecast
    case PostProcessedAnalysis
    case PostProcessedForecast
    case Nowcast
    case Hindcast
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        switch value {
            case 0: self = .Analysis
            case 1: self = .Initialization
            case 2: self = .Forecast
            case 3: self = .BiasCorrectedForecast
            case 4: self = .EnsembleForecast
            case 5: self = .ProbabilityForecast
            case 6: self = .ForecastError
            case 7: self = .AnalysisError
            case 8: self = .Observation
            case 9: self = .Climatological
            case 10: self = .ProbabilityWeightedForecast
            case 11: self = .BiasCorrectedEnsembleForecast
            case 12: self = .PostProcessedAnalysis
            case 13: self = .PostProcessedForecast
            case 14: self = .Nowcast
            case 15: self = .Hindcast
            case 255: self = .Missing
        default: if value >= 192 && value <= 254 { self = .ReservedForLocalUse } else { self = .Reserved }
        }
    }
}
