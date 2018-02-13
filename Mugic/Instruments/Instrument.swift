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
    
    let samplers: [AKSampler]
    let mixer = AKMixer()
    let midiFileName: String
    let rootSampler = AKSampler()
    let thirdSampler = AKSampler()
    let fifthSampler = AKSampler()
    let seventhSampler = AKSampler()
    var noteNumbers: [Int]
    
    init(midifileName: String = "Acoustic Guitars JNv2.4") {
        self.noteNumbers = []
        do {
            self.midiFileName = midifileName
            self.samplers = [self.rootSampler, self.thirdSampler, self.fifthSampler, self.seventhSampler]
            for sampler in self.samplers {
                try sampler.loadMelodicSoundFont(midifileName, preset: 0)
                self.mixer.connect(input: sampler)
            }
            
        } catch  {
            print("File not found")
        }
    }
    
    func stop() {
        let midiChannel = MIDIChannel()
        for (index, noteNumber) in self.noteNumbers.enumerated() {
            self.samplers[index].stop(noteNumber: MIDINoteNumber(noteNumber), channel: midiChannel)
        }
    }
}

