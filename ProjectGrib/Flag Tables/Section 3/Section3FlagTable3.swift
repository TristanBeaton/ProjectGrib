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
        var components = Array<Section3FlagTable3>()
        if (byte >> 5) & 0x1 == 0 { components.append(.iNotGiven) } else { components.append(.iGiven) }
        if (byte >> 4) & 0x1 == 0 { components.append(.jNotGiven) } else { components.append(.jGiven) }
        if (byte >> 3) & 0x1 == 0 { components.append(.uvNE) } else { components.append(.uvXY) }
        return components
    }
}
