//
//  DataSection.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

class DataSection {
    
    let length: UInt32
    let section: UInt8
    let data: Array<Double>
    
    init(_ stream:GribFileStream, _ length:UInt32, _ gdt:Template, _ drt:Template) throws {
        // Octets 1-4. Length of section in octets
        self.length = length
        // Octet 5. Number of section (7)
        self.section = 7
        // Octets 6-nn. Data
        if let gdt = gdt as? Section3Template0, let drt = drt as? Section5Template0 {
            // Prevents dividing by zero
            if drt.bitsPerValue != 0 {
                
                let refValue = Double(drt.referenceValue)
                let binaryScale = Double(drt.binaryScaleFactor)
                let decimalScale = Double(drt.decimalScaleFactor)
                
                let ref = pow(10, decimalScale) * refValue
                let scale = pow(10, decimalScale) * pow(2, binaryScale)
                
                let dataCount = (Int(length) - 5) * 8 / Int(drt.bitsPerValue)
                
                let latIncrement = gdt.iDirectionIncrement
                let lonIncrement = gdt.jDirectionIncrement
                
                let startLat = gdt.latitudeOfFirstGridPoint
                let startLon = gdt.longitudeOfFirstGridPoint
                
                var data = Array(repeating: 0.0, count: dataCount)
                var dataIndex = 0
                
                for latIndex in 0 ..< gdt.Nj {
                    for lonIndex in 0 ..< gdt.Ni {
                        let lat = startLat + (latIncrement * Double(latIndex))
                        let lon = startLon + (lonIncrement * Double(lonIndex))
                        data[dataIndex] = (ref + scale * Double(try stream.readUInt(Int(drt.bitsPerValue))))
                        print("\(lat), \(lon): \(round((data[dataIndex] - 27315) / 10) / 10)ºC")
                        dataIndex += 1
                    }
                }
                self.data = data
                return
            }
        }
        // Currently not supporting any other data sections at the moment.
        throw GribFileStreamError.invalidFile
    }
}
