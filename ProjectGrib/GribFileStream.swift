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
    
    fileprivate init(_ raw:UInt8) {
        if raw == 1 { self = .one; return }
        self = .zero
    }
}

public enum GribFileStreamError: Error {
    case endOfFile
    case unknown
}
// MARK: - GribFileStream
public final class GribFileStream: InputStream {
    /**
     The amount of bytes currently read from the GRIB file.
     
     - returns:
     The amount of bytes read as an Int.
     
     This is so when reading the GRIB file it is possible to track how much of the file has been read.
     */
    private(set) var totalBytesRead = 0
    /**
     Stores an array of bits that are left over after splicing a byte.
     
     Since the Input Stream can only read bytes at a time, the ability to read bits is a bit more complicated. So whenever the number of bits needed to be read is not divisible by 8, these left over bits get stored and become the start of the next batch of bits read.
     */
    private var bits = Array<UInt8>()
}
// MARK: - Reading Bytes from GRIB File
public extension GribFileStream {
    /**
     Read a byte from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A UInt8 (byte).
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     
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
        // Update total bytes read count
        totalBytesRead += 1
        // Return the bytes if there was no error.
        return buffer
    }
    /**
     Read a defined amount of bytes from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     An array of bytes to the amount specified, or until the end of file was reached.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - parameters:
        - length: The maximum amount of bytes to be read from the GRIB file.
     
     - Version:
     0.1
     
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
        // Update total bytes read count
        totalBytesRead += buffer.count
        // Return the bytes if there was no error.
        return buffer
    }
}
// MARK: - Reading Bits from GRIB File
extension GribFileStream {
    /**
     Reads a byte from the GRIB file and slices it into bits to store in the bit buffer.
     
     - Author:
     Tristan Beaton
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    private func loadBitBuffer() throws {
        // Read byte from the GRIB file.
        let byte = try readByte()
        // Divide the byte into bits.
        bits.append(byte >> 7)
        bits.append(byte >> 6 & 0x1)
        bits.append(byte >> 5 & 0x1)
        bits.append(byte >> 4 & 0x1)
        bits.append(byte >> 3 & 0x1)
        bits.append(byte >> 2 & 0x1)
        bits.append(byte >> 1 & 0x1)
        bits.append(byte & 0x1)
    }
    /**
     Read a bit from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A bit.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readBit() throws -> Bit {
        // Check the bit buffer for a bit.
        if let bit = bits.first {
            // Since there is a bit, we will use that and also remove it from the buffer.
            bits.removeFirst()
            // Return bit.
            return Bit(bit)
        }
        // Otherwise we need to read it from the GRIB file.
        let byte = try readByte()
        // Divide the byte into bits.
        let bit = byte >> 7
        bits.append(byte >> 6 & 0x1)
        bits.append(byte >> 5 & 0x1)
        bits.append(byte >> 4 & 0x1)
        bits.append(byte >> 3 & 0x1)
        bits.append(byte >> 2 & 0x1)
        bits.append(byte >> 1 & 0x1)
        bits.append(byte & 0x1)
        // Return bit
        return Bit(bit)
    }
    /**
     Read a defined amount of bits from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     An array of bits to the amount specified, or until the end of file was reached.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - parameters:
        - length: The maximum amount of bits to be read from the GRIB file.
     
     - Version:
     0.1
     */
    func readBits(_ length:Int) throws -> Array<Bit> {
        // Check if we need to read more bytes into the bit buffer.
        while bits.count < length {
            // If we cannot read anymore bytes, just return what we have.
            do { try loadBitBuffer() }
            // If we haven't reached the end of the file, some other error must have occured, so pass it on and don't continue.
            catch { switch error { case GribFileStreamError.endOfFile: break; default: throw error }}
        }
        // Determine whether we have the correct amount of bits.
        if bits.count >= length {
            // Store those bits.
            let rawBits = bits[0 ..< length]
            // Remove the bits from the buffer
            bits.removeSubrange(0 ..< length)
            // Return bits.
            return rawBits.map { Bit($0) }
        } else {
            // Check that we have bits.
            if bits.count == 0 { throw GribFileStreamError.endOfFile }
            // Return bits.
            return bits.map { Bit($0) }
        }
    }
}
// MARK: - Reading Unsigned Integers from GRIB File
extension GribFileStream {
    /**
     Reads a UInt8 from the GRIB file.
    
     - Author:
     Tristan Beaton
     
     - returns:
     A UInt8.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readUI8() throws -> UInt8 {
        // Check if there is any bits in the bit buffer.
        if bits.count == 0 { return try readByte() }
        // Load bits into bit buffer.
        while bits.count >= 8 { try loadBitBuffer() }
        // Create byte from the bit buffer.
        let byte = bits[0] << 7 | bits[1] << 6 | bits[2] << 5 | bits[3] << 4 | bits[4] << 3 | bits[5] << 2 | bits[6] << 1 | bits[7]
        // Remove bits from bit buffer.
        bits.removeSubrange(0 ..< 8)
        // Return byte.
        return byte
    }
    /**
     Reads a UInt16 from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A UInt16.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readUI16() throws -> UInt16 {
        // Read bytes from GRIB file.
        let bytes = [UInt16(try readUI8()), UInt16(try readUI8())]
        // Join bytes.
        return bytes[0] << 8 | bytes[1]
    }
    /**
     Reads a UInt32 from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A UInt32.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readUI32() throws -> UInt32 {
        // Read bytes from GRIB file.
        let bytes = [UInt32(try readUI8()), UInt32(try readUI8()), UInt32(try readUI8()), UInt32(try readUI8())]
        // Join bytes.
        return bytes[0] << 24 | bytes[1] << 16 | bytes[2] << 8 | bytes[3]
    }
    /**
     Reads a UInt64 from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A UInt64.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readUI64() throws -> UInt64 {
        // Read bytes from GRIB file.
        let bytes = [UInt64(try readUI8()), UInt64(try readUI8()), UInt64(try readUI8()), UInt64(try readUI8()),
                     UInt64(try readUI8()), UInt64(try readUI8()), UInt64(try readUI8()), UInt64(try readUI8())]
        // Join bytes.
        return bytes[0] << 56 | bytes[1] << 48 | bytes[2] << 40 | bytes[3] << 32 | bytes[4] << 24 | bytes[5] << 16 | bytes[6] << 8 | bytes[7]
    }
}
