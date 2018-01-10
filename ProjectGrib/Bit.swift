//
//  Bit.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

public enum Bit {
    case zero
    case one
    
    init(_ raw:UInt8) {
        if raw == 0 { self = .zero; return }
        self = .one
    }
}
