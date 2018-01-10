//
//  ProductDefinitionSection.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

class ProductDefinitionSection {
    
    let length: UInt32
    let section: UInt8
    let NV: UInt16
    let templateNo: UInt16
    let template: Template
    
    init(_ stream:GribFileStream, _ length:UInt32) throws {
        // Octets 1-4. Length of section in octets
        self.length = length
        // Octet 5. Number of section (4)
        self.section = 4
        // Octets 6-7. Number of coordinates values after Template
        self.NV = try stream.readUI16()
        // Octets 8-9. Product Definition Template Number
        self.templateNo = try stream.readUI16()
        // Octets 10-nn. Product Definition Template
        self.template = try ProductDefinitionSection.template(stream, self.templateNo)
    }
    
    static private func template(_ stream:GribFileStream, _ templateNo:UInt16) throws -> Template {
        switch templateNo {
            // Analysis or Forecast at a Horizontal Level or in a Horizontal Layer at a Point in Time
            case 0: return try Section4Template0(stream)
            // Throw error for unsupported templates.
            default: throw GribFileStreamError.unsupportedTemplate(4, templateNo)
        }
    }
}
