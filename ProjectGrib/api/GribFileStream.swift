//
//  GribFileStream.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

// MARK: - GribFileStream
final class GribFileStream {
    /**
     An input stream to read data from the GRIB file.
     */
    private(set) var stream: InputStream
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
    /**
     Returns a boolean if there is data still avalible to be from the GRIB file.
     
     - returns:
     A Bool.
     */
    var hasBytesAvailable: Bool { return stream.hasBytesAvailable }
    
    // Initialise
    init(at path:String) throws {
        // Try to create a stream.
        if let stream = InputStream(fileAtPath: path) {
            // Open stream so we can read it.
            stream.open()
            // Save the stream to the stream reference.
            self.stream = stream
            // Return since we have finished initialising.
            return
        }
        // Throw an error if we get to this point
        throw GribFileStreamError.cannotReadFile
    }
}
// MARK: - Reading Bytes from GRIB File
extension GribFileStream {
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
        if !hasBytesAvailable { throw GribFileStreamError.endOfFile }
        // Create a buffer to store the byte read from the GRIB file.
        var buffer = UInt8()
        // Read the GRIB file and save the response so we can check for any errors.
        let response = stream.read(&buffer, maxLength: MemoryLayout<UInt8>.size)
        // Determine any errors from the response.
        switch response {
            case 0: throw GribFileStreamError.endOfFile
            case -1: throw stream.streamError ?? GribFileStreamError.unknown
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
        if !hasBytesAvailable { throw GribFileStreamError.endOfFile }
        // Create a buffer to store the bytes read from the GRIB file.
        var buffer = Array<UInt8>()
        // Read the GRIB file and save the response so we can check for any errors.
        let response = stream.read(&buffer, maxLength: MemoryLayout<UInt8>.size * length)
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
    /**
     Read a defined amount of bits from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     An UInt of bits to the amount specified, or until the end of file was reached.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - parameters:
     - length: The maximum amount of bits to be read from the GRIB file.
     
     - Version:
     0.1
     */
    func readUInt(_ length:Int) throws -> UInt {
        // Create a variable to store bits.
        var value = UInt()
        // Read bytes from GRIB file.
        let bits = try readBits(length)
        // If the bits amount is more than 8, then we'll use loop unrolling to improve performance.
        if length >= 8 {
            for i in 0 ..< Int(floor(Double(length) / 8)) {
                value = value << 1 | (bits[(8 * i) + 0] == .zero ? 0 : 1)
                value = value << 1 | (bits[(8 * i) + 1] == .zero ? 0 : 1)
                value = value << 1 | (bits[(8 * i) + 2] == .zero ? 0 : 1)
                value = value << 1 | (bits[(8 * i) + 3] == .zero ? 0 : 1)
                value = value << 1 | (bits[(8 * i) + 4] == .zero ? 0 : 1)
                value = value << 1 | (bits[(8 * i) + 5] == .zero ? 0 : 1)
                value = value << 1 | (bits[(8 * i) + 6] == .zero ? 0 : 1)
                value = value << 1 | (bits[(8 * i) + 7] == .zero ? 0 : 1)
            }
        }
        // Check if there is any bits left from the loop unrolling.
        if length % 8 != 0 {
            // Any amount less than 8 or left over from the loop unrolling, we'll just do individually.
            for i in 0 ..< length % 8 {
                value = value << 1 | (bits[(8 * Int(floor(Double(length) / 8))) + i] == .zero ? 0 : 1)
            }
        }
        return value
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
     Reads a specified amount of UInt8 from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     An array of UInt8.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readUI8(_ length:Int) throws -> Array<UInt8> {
        // Read bytes from GRIB file.
        var bytes = Array<UInt8>()
        // If the bytes amount is more than 8, then we'll use loop unrolling to improve performance.
        if length >= 8 {
            for _ in 0 ..< Int(floor(Double(length) / 8)) {
                bytes.append(try readUI8())
                bytes.append(try readUI8())
                bytes.append(try readUI8())
                bytes.append(try readUI8())
                bytes.append(try readUI8())
                bytes.append(try readUI8())
                bytes.append(try readUI8())
                bytes.append(try readUI8())
            }
        }
        // Check if there is any bytes left from the loop unrolling.
        if length % 8 != 0 {
            // Any amount less than 8 or left over from the loop unrolling, we'll just do individually.
            for _ in 0 ..< length % 8 { bytes.append(try readUI8()) }
        }
        return bytes
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
// MARK: - Reading Signed Integers from GRIB File
extension GribFileStream {
    /**
     Reads a Int8 from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A Int8.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readInt8() throws -> Int8 {
        // Read a byte and cast it to Int8
        return Int8(bitPattern: try readUI8())
    }
    /**
     Reads a Int16 from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A Int16.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readInt16() throws -> Int16 {
        // Read a byte and cast it to Int16
        return Int16(bitPattern: try readUI16())
    }
    /**
     Reads a Int32 from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A Int32.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readInt32() throws -> Int32 {
        // Read a byte and cast it to Int32
        return Int32(bitPattern: try readUI32())
    }
    /**
     Reads a Int64 from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A Int64.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readInt64() throws -> Int64 {
        // Read a byte and cast it to Int64
        return Int64(bitPattern: try readUI64())
    }
}
// MARK: - Reading Floating Points from GRIB File
extension GribFileStream {
    // MARK: - Floating Points
    func readFloat() throws -> Float32 {
        // Create a buffer to store Float.
        var f:Float32 = 0.0
        // Convert bytes to float.
        memcpy(&f, try self.readUI8(4).reversed(), 4)
        // Return Float
        return f
    }
}
// MARK: - Reading Text from GRIB File
extension GribFileStream {
    /**
     Reads a String from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     An optional String. This is because the encoding can fail.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readText(_ length:Int, encoding:String.Encoding = .utf8) throws -> String? {
        // Read bytes from GRIB file.
        let bytes = try readUI8(length)
        // Convert to a string.
        return String(bytes: bytes, encoding: encoding)
    }
}
// MARK: - Reading Booleans from GRIB File
extension GribFileStream {
    /**
     Reads a Boolean from the GRIB file.
     
     - Author:
     Tristan Beaton
     
     - returns:
     A Bool.
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func readBool() throws -> Bool {
        // Read byte from GRIB file.
        return try readUI8() > 0
    }
}
// MARK: - Scanning a GRIB File.
extension GribFileStream {
    /**
     Skips ahead a specified amount of bytes.
     
     - Author:
     Tristan Beaton
     
     - throws:
     An error of type 'GribFileStreamError'.
     
     - Version:
     0.1
     */
    func skip(_ length:Int = 1) throws {
        // If the skip amount is more than 8, then we'll use loop unrolling to improve performance.
        if length >= 8 {
            for _ in 0 ..< Int(floor(Double(length) / 8)) {
                let _ = try readUI8()
                let _ = try readUI8()
                let _ = try readUI8()
                let _ = try readUI8()
                let _ = try readUI8()
                let _ = try readUI8()
                let _ = try readUI8()
                let _ = try readUI8()
            }
        }
        // Check if there is any skips left from the loop unrolling.
        if length % 8 == 0 { return }
        // Any amount less than 8 or left over from the loop unrolling, we'll just do individually.
        for _ in 0 ..< length % 8 { let _ = try readUI8() }
    }
}
