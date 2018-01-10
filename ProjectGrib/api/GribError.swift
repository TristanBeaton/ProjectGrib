//
//  GribFileStreamError.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum GribFileStreamError: Error {
    case cannotReadFile
    case endOfFile
    case fileNotFound
    case invalidFile
    case invalidSection(UInt8)
    case invalidString
    case unknown
    case unsupportedTemplate(Int, UInt16)
}
