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
        var bits = Array<UInt8>()
        for i in 0 ..< 8 { bits.append((byte << UInt8(i)) >> 7) }
        var components = Array<Section3FlagTable4>()
        if bits[0] == 0 { components.append(.IncrementI) } else { components.append(.DecrementI) }
        if bits[1] == 0 { components.append(.DecrementJ) } else { components.append(.IncrementJ) }
        if bits[2] == 0 { components.append(.ConsecutiveI) } else { components.append(.ConsecutiveJ) }
        if bits[3] == 0 { components.append(.SameDirection) } else { components.append(.OppositeDirection) }
        return components
    }
}
