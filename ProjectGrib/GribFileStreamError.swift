//
//  GribFileStreamError.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

public enum GribFileStreamError: Error {
    case endOfFile
    case invalidString
    case unknown
}
