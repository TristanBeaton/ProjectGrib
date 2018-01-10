//
//  Section4CodeTable4.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section4CodeTable4 {
    case Minute
    case Hour
    case Day
    case Month
    case Year
    case Decade
    case Normal
    case Century
    case ThreeHours
    case SixHours
    case TwelveHours
    case Second
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        switch value {
            case 0: self = .Minute
            case 1: self = .Hour
            case 2: self = .Day
            case 3: self = .Month
            case 4: self = .Year
            case 5: self = .Decade
            case 6: self = .Normal
            case 7: self = .Century
            case 10: self = .ThreeHours
            case 11: self = .SixHours
            case 12: self = .TwelveHours
            case 13: self = .Second
            case 255: self = .Missing
            default: if value >= 192 && value <= 254 { self = .ReservedForLocalUse } else { self = .Reserved }
        }
    }
}
