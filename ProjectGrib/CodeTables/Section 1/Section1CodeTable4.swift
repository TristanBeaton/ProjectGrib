//
//  Section1CodeTable4.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section1CodeTable4 {
    case AnalysisProducts
    case ForecastProducts
    case AnalysisAndForecastProducts
    case ControlForecastProducts
    case PerturbedForecastProducts
    case ControlAndPerturbedForecastProducts
    case ProcessedSatelliteObservations
    case ProcessedRadarObservations
    case EventProbability
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        // TODO Change this init method to a switch
        if value == 0 { self = .AnalysisProducts; return }
        if value == 1 { self = .ForecastProducts; return }
        if value == 2 { self = .AnalysisAndForecastProducts; return }
        if value == 3 { self = .ControlForecastProducts; return }
        if value == 4 { self = .PerturbedForecastProducts; return }
        if value == 5 { self = .ControlAndPerturbedForecastProducts; return }
        if value == 6 { self = .ProcessedSatelliteObservations; return }
        if value == 7 { self = .ProcessedRadarObservations; return }
        if value == 8 { self = .EventProbability; return }
        if value >= 9 && value <= 191 { self = .Reserved; return }
        if value >= 192 && value <= 254 { self = .ReservedForLocalUse; return }
        self = .Missing
    }
}
