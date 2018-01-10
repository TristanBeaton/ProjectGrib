//
//  Section3CodeTable2.swift
//  ProjectGrib
//
//  Created by Tristan Beaton on 10/01/18.
//  Copyright © 2018 Tristan Beaton. All rights reserved.
//

import Foundation

enum Section3CodeTable2 {
    case SphericalRadius6367470
    case SphericalRadiusSpecified
    case OblateSpheroidIAU
    case OblateSpheroidSpecifiedKilometers
    case OblateSpheroidIAGGRS80
    case WGS84
    case SphericalRadius6371229
    case OblateSpheroidSpecifiedMeters
    case SphericalRadius6371200WGS84
    case Airy1830Spheroid
    case Reserved
    case ReservedForLocalUse
    case Missing
    
    init(_ value:UInt8) {
        switch value {
            case 0: self = .SphericalRadius6367470
            case 1: self = .SphericalRadiusSpecified
            case 2: self = .OblateSpheroidIAU
            case 3: self = .OblateSpheroidSpecifiedKilometers
            case 4: self = .OblateSpheroidIAGGRS80
            case 5: self = .WGS84
            case 6: self = .SphericalRadius6371229
            case 7: self = .OblateSpheroidSpecifiedMeters
            case 8: self = .SphericalRadius6371200WGS84
            case 9: self = .Airy1830Spheroid
            case 255: self = .Missing
            default: if value >= 192 && value <= 254 { self = .ReservedForLocalUse } else { self = .Reserved }
        }
    }
}
