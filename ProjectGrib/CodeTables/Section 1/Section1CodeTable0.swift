//
//  Section1CodeTable0.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section1CodeTable0 {
    case Experimental
    case Nov072001
    case Nov042003
    case Nov022005
    case Nov072007
    case Nov042009
    case Sep152010
    case May042011
    case Nov022011
    case May022012
    case Nov072012
    case May082013
    case Nov142013
    case May072014
    case Nov052014
    case FutureVersion
    case Missing
    
    init(_ value:UInt8) {
        // TODO Change this init method to a switch
        if value == 0 { self = .Experimental; return }
        if value == 1 { self = .Nov072001; return }
        if value == 2 { self = .Nov042003; return }
        if value == 3 { self = .Nov022005; return }
        if value == 4 { self = .Nov072007; return }
        if value == 5 { self = .Nov042009; return }
        if value == 6 { self = .Sep152010; return }
        if value == 7 { self = .May042011; return }
        if value == 8 { self = .Nov022011; return }
        if value == 9 { self = .May022012; return }
        if value == 10 { self = .Nov072012; return }
        if value == 11 { self = .May082013; return }
        if value == 12 { self = .Nov142013; return }
        if value == 13 { self = .May072014; return }
        if value == 14 { self = .Nov052014; return }
        if value >= 15 && value <= 254 { self = .FutureVersion; return }
        self = .Missing
    }
}
