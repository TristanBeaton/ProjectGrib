//
//  Section3Template0.swift
//  Project Grib
//
//  Created by Tristan Beaton on 19/09/17.
//  Copyright © 2017 Tristan Beaton. All rights reserved.
//

import Foundation

class Section3Template0 : Template {
    let shapeOfTheEarth: Section3CodeTable2
    let scaleFactorOfRadiusOfSphericalEarth: UInt8
    let scaledValueOfRadiusOfSphericalEarth: UInt32
    let scaleFactorOfEarthMajorAxis: UInt8
    let scaledValueOfEarthMajorAxis: UInt32
    let scaleFactorOfEarthMinorAxis: UInt8
    let scaledValueOfEarthMinorAxis: UInt32
    let Ni: UInt32
    let Nj: UInt32
    let basicAngleOfTheInitialProductionDomain: Double
    let subdivisionsOfBasicAngle: UInt32
    let latitudeOfFirstGridPoint: Double
    let longitudeOfFirstGridPoint: Double
    let resolutionAndComponentFlags: Array<Section3FlagTable3>
    let latitudeOfLastGridPoint: Double
    let longitudeOfLastGridPoint: Double
    let iDirectionIncrement: Double
    let jDirectionIncrement: Double
    let scanningMode: Array<Section3FlagTable4>
    
    init(_ stream:GribFileStream) throws {
        // Octet 15. Shape of the earth
        self.shapeOfTheEarth = Section3CodeTable2(try stream.readUI8())
        // Octet 16. Scale factor of radius of spherical earth
        self.scaleFactorOfRadiusOfSphericalEarth = try stream.readUI8()
        // Octets 17-20. Scaled value of radius of spherical earth
        self.scaledValueOfRadiusOfSphericalEarth = try stream.readUI32()
        // Octet 21. Scale factor of major axis of oblate spheroid earth
        self.scaleFactorOfEarthMajorAxis = try stream.readUI8()
        // Octets 22-25. Scaled value of major axis of oblate spheroid earth
        self.scaledValueOfEarthMajorAxis = try stream.readUI32()
        // Octet 26. Scale factor of minor axis of oblate spheroid earth
        self.scaleFactorOfEarthMinorAxis = try stream.readUI8()
        // Octets 27-30. Scaled value of minor axis of oblate spheroid earth
        self.scaledValueOfEarthMinorAxis = try stream.readUI32()
        // Octets 31-34. Ni - number of points along a parallel
        self.Ni = try stream.readUI32()
        // Octets 35-38. Nj - number of points along a meridian
        self.Nj = try stream.readUI32()
        // Octets 39-42. Basic angle of the initial production domain
        self.basicAngleOfTheInitialProductionDomain = Double(try stream.readUI32()) / 1000000
        // Octets 43-46. Subdivisions of basic angle used to define extreme longitudes and latitudes, and direction increments
        self.subdivisionsOfBasicAngle = try stream.readUI32()
        // Octets 47-50. La1 - latitude of first grid point
        self.latitudeOfFirstGridPoint = Double(try stream.readInt32()) / 1000000
        // Octets 51-54. Lo1 - longitude of first grid point
        self.longitudeOfFirstGridPoint = Double(try stream.readInt32()) / 1000000
        // Octet 55. Resolution and component flags
        self.resolutionAndComponentFlags = Section3FlagTable3.components(try stream.readUI8())
        // Octets 56-59. La2 - latitude of last grid point
        self.latitudeOfLastGridPoint = Double(try stream.readInt32()) / 1000000
        // Octet 60-63. Lo2 - longitude of last grid point
        self.longitudeOfLastGridPoint = Double(try stream.readInt32()) / 1000000
        // Octets 64-67. Di - i direction increment
        self.iDirectionIncrement = Double(try stream.readUI32()) / 1000000
        // Octets 68-71. Dj - j direction increment
        self.jDirectionIncrement = Double(try stream.readUI32()) / 1000000
        // Octet 72. Scanning mode
        self.scanningMode = Section3FlagTable4.components(try stream.readUI8())
        // Octets 73-nn. List of number of points along each meridian or parallel
    }
}
