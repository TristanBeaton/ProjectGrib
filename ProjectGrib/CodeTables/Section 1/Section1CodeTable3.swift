//
//  Section1CodeTable3.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section1CodeTable3 {
    case OperationalProducts
    case OperationalTestProducts
    case ResearchProducts
    case ReanalysisProducts
    case TIGGE
    case TIGGETest
    case S2SOperationalProducts
    case S2STestProducts
    case UERRA
    case UERRATest
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        // TODO Change this init method to a switch
        if value == 0 { self = .OperationalProducts; return }
        if value == 1 { self = .OperationalTestProducts; return }
        if value == 2 { self = .ResearchProducts; return }
        if value == 3 { self = .ReanalysisProducts; return }
        if value == 4 { self = .TIGGE; return }
        if value == 5 { self = .TIGGETest; return }
        if value == 6 { self = .S2SOperationalProducts; return }
        if value == 7 { self = .S2STestProducts; return }
        if value == 8 { self = .UERRA; return }
        if value == 9 { self = .UERRATest; return }
        if value >= 10 && value <= 191 { self = .Reserved; return }
        if value >= 192 && value <= 254 { self = .ReservedForLocalUse; return }
        self = .Missing
    }
}
