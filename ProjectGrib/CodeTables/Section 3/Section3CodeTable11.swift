//
//  Section3CodeTable11.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section3CodeTable11 {
    case None
    case Parallels
    case ExtremeCoordinateValues
    case Latitudes
    case Reserved
    case Missing
    
    init(_ value:UInt8) {
        switch value {
            case 0: self = .None
            case 1: self = .Parallels
            case 2: self = .ExtremeCoordinateValues
            case 3: self = .Latitudes
            case 255: self = .Missing
            default:  self = .Reserved
        }
    }
}
