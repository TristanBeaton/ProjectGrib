//
//  Section4CodeTable2.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section4CodeTable2 {
    
    case Ucomponent
    case Vcomponent
    case Temperature
    case Pressure
    case Missing
    
    init(_ codeTable: Section4CodeTable1, _ value:UInt8) {
        switch codeTable {
            case .Momentum:
                switch value {
                    case 2: self = .Ucomponent
                    case 3: self = .Vcomponent
                    default: self = .Missing
                }
            case .Temperature:
                switch value {
                    case 0: self = .Temperature
                    default: self = .Missing
                }
            default: self = .Missing
        }
    }
}
