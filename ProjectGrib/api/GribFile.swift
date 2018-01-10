//
//  GribFile.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

public final class GribFile {
    // Reference to the file stream.
    private var stream: GribFileStream
    // Initialise
    public init(at path:String) throws {
        // Try to create a stream with file.
        let stream = try GribFileStream(at: path)
        // Save stream to reference variable.
        self.stream = stream
        // Start reading file.
        try moveToStart()
        // Return since we have finished initialising.
        return
    }
    
}
// MARK: - Indentification Section
extension GribFile {
    /**
     This will scan the file to look for the start.
     
     - Author:
     Tristan Beaton
     
     - throws:
     A 'GribFileStreamError' if the file is invalid.
     
     - Version:
     0.1
     
     The start of the GRIB file 4 bytes that represent the letters 'G', 'R', 'I' and 'B'. This function scans the file to find these four letters.
     */
    private func moveToStart() throws {
        // Create a 'GRIB' string reference.
        let grib = "GRIB".utf8.map{ UInt8($0) }
        // Keep a record if we find a 'G'.
        var found = ""
        // Scan file for 'GRIB'.
        scan: while stream.hasBytesAvailable {
            // Read byte from GRIB file.
            let byte = try stream.readUI8()
            // Check if is equal to 'G'.
            switch byte {
            // Set found to 'G' since it is the first letter of 'GRIB'
            case grib[0]: found = "G"
            // If found == 'G' then 'G' was the previous byte, so if this byte is 'R' we are getting close.
            case grib[1]: if found == "G" { found = "GR" } else { found = "" }
            // If found == 'GR' then 'R' was the previous byte, so if this byte is 'I' we are getting close.
            case grib[2]: if found == "GR" { found = "GRI" } else { found = "" }
            // If found == 'GRI' then 'I' was the previous byte, so if this byte is 'B' we have found the start.
            case grib[3]: if found == "GRI" { found = "GRIB"; break scan}
            // Any other data is just skipped.
            default: found = ""
            }
        }
        // Check whether the start was found.
        if found == "GRIB" { return }
        // Otherwise this must not be a valid GRIB file so throw an error.
        throw GribFileStreamError.invalidFile
    }
}
