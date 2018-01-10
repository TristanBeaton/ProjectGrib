//
//  Section6CodeTable0.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section6CodeTable0 {
    case Section
    case Predetermined
    case PreviousMessage
    case NotApplicable
    
    init(_ value:UInt8) {
        switch value {
            case 0: self = .Section
            case 254: self = .PreviousMessage
            case 255: self = .NotApplicable
            default: self = .Predetermined
        }
    }
}
