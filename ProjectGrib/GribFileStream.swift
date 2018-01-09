//
//  GribFileStream.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

public enum Bit {
    case zero
    case one
}

public enum GribFileStreamError: Error {
    case endOfFile
    case unknown
}

public final class GribFileStream: InputStream {
    /**
     The amount of bytes currently read from the GRIB file.
     
     - returns:
     The amount of bytes read as an Int.
     
     This is so when reading the GRIB file it is possible to track how much of the file has been read.
     */
    var totalBytesRead = 0
    /**
     Stores an array of bits that are left over after splicing a byte.
     
     - returns:
     An array of Bits, which are even ones or zeros.
     
     Since the Input Stream can only read bytes at a time, the ability to read bits is a bit more complicated. So whenever the number of bits needed to be read is not divisible by 8, these left over bits get stored and become the start of the next batch of bits read.
     */
    var bits = Array<Bit>()
}

public extension GribFileStream {
    /**
     Read a byte from the GRIB file.
     
     - returns:
     A UInt8 (byte).
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     This is for reading a raw byte from the GRIB file. For any specific data type, use the function that reads and returns that data type.
     */
    func readByte() throws -> UInt8 {
        // Check that there is data avalible to be read from the GRIB file.
        if hasBytesAvailable { throw GribFileStreamError.endOfFile }
        // Create a buffer to store the byte read from the GRIB file.
        var buffer = UInt8()
        // Read the GRIB file and save the response so we can check for any errors.
        let response = read(&buffer, maxLength: MemoryLayout<UInt8>.size)
        // Determine any errors from the response.
        switch response {
            case 0: throw GribFileStreamError.endOfFile
            case -1: throw self.streamError ?? GribFileStreamError.unknown
            default: break
        }
        // Return the bytes if there was no error.
        return buffer
    }
    /**
     Read a defined amount of bytes from the GRIB file.
     
     - returns:
     An array of bytes to the amount specified, or until the end of file was reached.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - parameters:
        - length: The maximum amount of bytes to be read from the GRIB file.
     
     This is for reading raw bytes from the GRIB file. For any specific data type, use the function that reads and returns that data type.
     */
    func readBytes(_ length:Int) throws -> Array<UInt8> {
        // Check that there is data avalible to be read from the GRIB file.
        if hasBytesAvailable { throw GribFileStreamError.endOfFile }
        // Create a buffer to store the bytes read from the GRIB file.
        var buffer = Array<UInt8>()
        // Read the GRIB file and save the response so we can check for any errors.
        let response = read(&buffer, maxLength: MemoryLayout<UInt8>.size * length)
        // Determine any errors from the response.
        switch response {
            case 0: throw GribFileStreamError.endOfFile
            case -1: throw GribFileStreamError.unknown
            default: break
        }
        // Return the bytes if there was no error.
        return buffer
    }
}
