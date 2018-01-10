//
//  Section3FlagTable3.swift
//  Project Grib
//
//  Created by Tristan Beaton on 19/09/17.
//  Copyright © 2017 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section3FlagTable3 {
    case iNotGiven
    case iGiven
    case jNotGiven
    case jGiven
    case uvNE
    case uvXY
    
    static func components(_ byte:UInt8) -> Array<Section3FlagTable3> {
        var bits = Array<UInt8>()
        for i in 0 ..< 8 { bits.append((byte << UInt8(i)) >> 7) }
        var components = Array<Section3FlagTable3>()
        if bits[2] == 0 { components.append(.iNotGiven) } else { components.append(.iGiven) }
        if bits[3] == 0 { components.append(.jNotGiven) } else { components.append(.jGiven) }
        if bits[4] == 0 { components.append(.uvNE) } else { components.append(.uvXY) }
        return components
    }
}
