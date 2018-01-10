//
//  IndicatorSection.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

class IndicatorSection {
    
    let disipline: Section0CodeTable0
    let edition: UInt8
    let length: UInt64
    
    init(_ stream:GribFileStream) throws {
        // Octets 1-4. GRIB" (coded according to the International Alphabet No. 5.)
        // Octets 5-6. Reserved
        let _ = try stream.skip(2)
        // Octet 7. Discipline - GRIB Master Table Number (see Code Table 0.0)
        self.disipline = Section0CodeTable0(try stream.readUI8())
        // Octet 8. GRIB Edition Number (currently 2)
        self.edition = try stream.readUI8()
        // Octets 9-16. Total length of GRIB message in octets (including Section 0)
        self.length = try stream.readUI64()
    }
}
