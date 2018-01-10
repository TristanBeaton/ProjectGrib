//
//  Section1CodeTable2.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section1CodeTable2 {
    case Analysis
    case StartOfForecast
    case VerifyingTimeOfForecast
    case ObservationTime
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        // TODO Change this init method to a switch
        if value == 0 { self = .Analysis; return }
        if value == 1 { self = .StartOfForecast; return }
        if value == 2 { self = .VerifyingTimeOfForecast; return }
        if value == 3 { self = .ObservationTime; return }
        if value >= 4 && value <= 191 { self = .Reserved; return }
        if value >= 192 && value <= 254 { self = .ReservedForLocalUse; return }
        self = .Missing
    }
}
