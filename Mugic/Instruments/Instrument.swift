//
//  Instrument.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 1. 14..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation

enum BassCode: Double {
    case C = 261.626
    case D = 293.665
    case E = 329.628
    case F = 349.228
    case G = 391.995
    case A = 440.000
    case B = 493.883
}

enum DetailCode: Int {
    case Maj = 0
    case Min
    case Sus4
    case Dominent7th
}
