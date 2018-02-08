//
//  Instrument.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 1. 14..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

enum Note: Int {
    case C = 60
    case CSharp
    case D
    case DSharp
    case E
    case F
    case FSharp
    case G
    case GSharp
    case A
    case ASharp
    case B
}

enum Interval: Int {
    case NONE = 0
    case SECOND = 2
    case MAJ_TRIAD = 4
    case MIN_TRIAD = 3
    case PERFECT_FORTH = 5
    case PERFECT_FIFTH = 7
    case DOMINENT_SEVENTH = 10
    case MAJ_SEVENTH = 11
}

enum Modifier: Int {
    case Natural = 0
    case Sharp = 1
    case Flat = -1
}

enum Chord: Int {
    case maj = 0
    case add2
    case min
    case sus4
    case maj7
    case seventh
}

class Instrument {
    static let OCTAVE = 12
    static let AHz = 440
    static func frequency(_ note: Note, modifier: Modifier = .Natural, adding: Interval = .NONE, octave: Int = 0 ) -> Double {
        
        let n = note.rawValue + modifier.rawValue + adding.rawValue
        let octaveAdded = n + (OCTAVE * octave)
        let powValue = Double(octaveAdded - 49) / Double(OCTAVE)
        
        let frequency = pow(2, powValue) * Double(AHz)
        
        return frequency
    }
    
    static func adding(_ note: Note, modifier: Modifier = .Natural, interval: Interval = .NONE, octave: Int = 0 ) -> Int {
        
        let n = note.rawValue + modifier.rawValue + interval.rawValue
        let octaveAdded = n + (OCTAVE * octave)
        return octaveAdded
    }
    
    let instrument = AKMIDISampler()
    
    init(midifileName: String = "Sounds/Sampler Instruments/Acoustic Guitar") {
        do {
            try self.instrument.loadEXS24(midifileName)
        } catch  {
            print("File not found")
        }
    }
}

