//
//  BitmapSection.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

class BitmapSection {
    
    let length: UInt32
    let section: UInt8
    let bitMapIndicator: Section6CodeTable0
    
    init(_ stream:GribFileStream, _ length:UInt32) throws {
        // Octets 1-4. Length of section in octets
        self.length = length
        // Octet 5. Number of section (6)
        self.section = 6
        // Octet 6. Bit-map indicator
        self.bitMapIndicator = Section6CodeTable0(try stream.readUI8())
        // Octets 7-nn. Bit-map - Contiguous bits with a bit to data point correspondence, ordered as defined in Section 3.
        if length > 6 { try stream.skip(Int(self.length) - 6) }
    }
}
