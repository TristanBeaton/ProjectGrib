//
//  Section3FlagTable4.swift
//  Project Grib
//
//  Created by Tristan Beaton on 19/09/17.
//  Copyright © 2017 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section3FlagTable4 {
    case IncrementI
    case DecrementI
    case DecrementJ
    case IncrementJ
    case ConsecutiveI
    case ConsecutiveJ
    case SameDirection
    case OppositeDirection
    
    static func components(_ byte:UInt8) -> Array<Section3FlagTable4> {
        var components = Array<Section3FlagTable4>()
        if (byte >> 7) & 0x1 == 0 { components.append(.IncrementI) } else { components.append(.DecrementI) }
        if (byte >> 6) & 0x1 == 0 { components.append(.DecrementJ) } else { components.append(.IncrementJ) }
        if (byte >> 5) & 0x1 == 0 { components.append(.ConsecutiveI) } else { components.append(.ConsecutiveJ) }
        if (byte >> 4) & 0x1 == 0 { components.append(.SameDirection) } else { components.append(.OppositeDirection) }
        return components
    }
}
