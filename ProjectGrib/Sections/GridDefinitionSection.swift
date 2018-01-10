//
//  GridDefinitionSection.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

class GridDefinitionSection {
    
    let length: UInt32
    let section: UInt8
    let sourceOfGridDefinition: Section3CodeTable0
    let numberOfDataPoints: UInt32
    let numberOfOctectsForNumberOfPoints: UInt8
    let interpretationOfNumberOfPoints: Section3CodeTable11
    let templateNo: UInt16
    let template: Template

    init(_ stream:GribFileStream, _ length:UInt32) throws {
        // Octets 1-4. Length of section in octets
        self.length = length
        // Octet 5. Number of section (3)
        self.section = 3
        // Octet 6. Source of grid definition
        self.sourceOfGridDefinition = Section3CodeTable0(try stream.readUI8())
        // Octets 7-10. Number of data points
        self.numberOfDataPoints = try stream.readUI32()
        // Octet 11. Number of octets for optional list of numbers
        self.numberOfOctectsForNumberOfPoints = try stream.readUI8()
        // Octet 12. Interpretation of list of numbers
        self.interpretationOfNumberOfPoints = Section3CodeTable11(try stream.readUI8())
        // Octets 13-14. Grid Definition Template Number
        self.templateNo = try stream.readUI16()
        // Octets 15-xx. Grid Definition Template.
        self.template = try GridDefinitionSection.template(stream, self.templateNo)
    }
    
    static private func template(_ stream:GribFileStream, _ templateNo:UInt16) throws -> Template {
        switch templateNo {
            // Latitude Longitude Template
            case 0: return try Section3Template0(stream)
            // Throw error for unsupported templates.
            default: throw GribFileStreamError.unsupportedTemplate(3, templateNo)
        }
    }
}
