//
//  DataRepresentationSection.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

class DataRepresentationSection {
    
    let length: UInt32
    let section: UInt8
    let numberOfValues: UInt32
    let templateNo: UInt16
    let template: Template
    
    init(_ stream:GribFileStream, _ length:UInt32) throws {
        // Octets 1-4. Length of section in octets
        self.length = length
        // Octet 5. Number of section (5)
        self.section = 5
        // Octets 6-9. Number of data points where one or more values are specified in Section 7 when a bit map is present, total number of data points when a bit map is absent.
        self.numberOfValues = try stream.readUI32()
        // Octets 10-11. Data Representation Template Number
        self.templateNo = try stream.readUI16()
        // Octets 12-nn. Data Representation Template
        self.template = try DataRepresentationSection.template(stream, self.templateNo)
    }
    
    static private func template(_ stream:GribFileStream, _ templateNo:UInt16) throws -> Template {
        switch templateNo {
            // Grid Point Data Simple Packing
            case 0: return try Section5Template0(stream)
            // Throw error for unsupported templates.
            default: throw GribFileStreamError.unsupportedTemplate(5, templateNo)
        }
    }
}
