//
//  Section5Template0.swift
//  Project Grib
//
//  Created by Tristan Beaton on 20/09/17.
//  Copyright © 2017 Tristan Beaton. All rights reserved.
//

import Foundation

class Section5Template0 : Template {
    let referenceValue: Float32
    let binaryScaleFactor: Int16
    let decimalScaleFactor: Int16
    let bitsPerValue: UInt8
    let typeOfOriginalFieldValues: Section5CodeTable1
    
    init(_ stream:GribFileStream) throws {
        // Octets 12-15. Reference value (R)
        self.referenceValue = try stream.readFloat()
        // Octets 16-17. Binary scale factor (E)
        self.binaryScaleFactor = try stream.readInt16()
        // Octets 18-19. Decimal scale factor (D)
        self.decimalScaleFactor = try stream.readInt16()
        // Octet 20. Number of bits used for each packed value for simple packing, or for each group reference value for complex packing or spatial differencing
        self.bitsPerValue = try stream.readUI8()
        // Octet 21. Type of original field values
        self.typeOfOriginalFieldValues = Section5CodeTable1(try stream.readUI8())
    }
}
