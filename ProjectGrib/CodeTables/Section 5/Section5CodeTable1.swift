//
//  Section5CodeTable1.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section5CodeTable1 {
    case FloatingPoint
    case Integer
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        switch value {
            case 0: self = .FloatingPoint
            case 1: self = .Integer
            case 255: self = .Missing
            default: if value >= 192 && value <= 254 { self = .ReservedForLocalUse } else { self = .Reserved }
        }
    }
}
