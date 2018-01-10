//
//  Section4Template0.swift
//  Project Grib
//
//  Created by Tristan Beaton on 20/09/17.
//  Copyright © 2017 Tristan Beaton. All rights reserved.
//

import Foundation

class Section4Template0 : Template {
    let parameterCategory: Section4CodeTable1
    let parameterNumber: Section4CodeTable2
    let typeOfGeneratingProcess: Section4CodeTable3
    let backgroundProcess: UInt8
    let generatingProcessIdentifier: UInt8
    let hoursAfterDataCutoff: UInt16
    let minutesAfterDataCutoff: UInt8
    let indicatorOfUnitOfTimeRange: Section4CodeTable4
    let forecastTime: Int32
    let typeOfFirstFixedSurface: Section4CodeTable5
    let scaleFactorOfFirstFixedSurface: Int8
    let scaledValueOfFirstFixedSurface: UInt32
    let typeOfSecondFixedSurface: Section4CodeTable5
    let scaleFactorOfSecondFixedSurface: Int8
    let scaledValueOfSecondFixedSurface: UInt32
    
    init(_ stream:GribFileStream) throws {
        // Octet 10. Parameter category
        self.parameterCategory = Section4CodeTable1(try stream.readUI8())
        // Octet 11. Parameter number
        self.parameterNumber = Section4CodeTable2(parameterCategory, try stream.readUI8())
        // Octet 12. Type of generating process
        self.typeOfGeneratingProcess = Section4CodeTable3(try stream.readUI8())
        // Octet 13. Background generating process identifier
        self.backgroundProcess = try stream.readUI8()
        // Octet 14. Analysis or forecast generating processes identifier
        self.generatingProcessIdentifier = try stream.readUI8()
        // Octets 15-16. Hours of observational data cutoff after reference time
        self.hoursAfterDataCutoff = try stream.readUI16()
        // Octet 17. Minutes of observational data cutoff after reference time
        self.minutesAfterDataCutoff = try stream.readUI8()
        // Octet 18. Indicator of unit of time range
        self.indicatorOfUnitOfTimeRange = Section4CodeTable4(try stream.readUI8())
        // Octets 19-22. Forecast time in units defined by octet 18
        self.forecastTime = try stream.readInt32()
        // Octet 23. Type of first fixed surface
        self.typeOfFirstFixedSurface = Section4CodeTable5(try stream.readUI8())
        // Octet 24. Scale factor of first fixed surface
        self.scaleFactorOfFirstFixedSurface = try stream.readInt8()
        // Octets 25-28. Scaled value of first fixed surface
        self.scaledValueOfFirstFixedSurface = try stream.readUI32()
        // Octet 29. Type of second fixed surface
        self.typeOfSecondFixedSurface = Section4CodeTable5(try stream.readUI8())
        // Octet 30. Scale factor of second fixed surface
        self.scaleFactorOfSecondFixedSurface = try stream.readInt8()
        // Octets 31-34. Scaled value of second fixed surface
        self.scaledValueOfSecondFixedSurface = try stream.readUI32()
    }
}
