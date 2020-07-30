//
//  ChordInstrument.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/06/20.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

class ChordInstrument: Instrument {
    
    var numberOfPolyphonic: Int
    var noteNumbers: Set<Int>
    
    override init() {
        self.noteNumbers = []
        self.numberOfPolyphonic = 0
        super.init()
    }
    
    static func adding(_ note: Note, modifier: Modifier = .Natural, interval: Interval = .NONE, octave: Int = 0 ) -> Int {
        
        let n = note.rawValue + modifier.rawValue + interval.rawValue
        let octaveAdded = n + (OCTAVE * octave)
        return octaveAdded
    }
    
    func stop() {
        let midiChannel = MIDIChannel()
        self.noteNumbers.forEach {
            try? self.sampler.stop(noteNumber: MIDINoteNumber($0), channel: midiChannel)
        }
        self.noteNumbers = []
    }
    
    func play() {
        let midiChannel = MIDIChannel()
        self.noteNumbers.forEach {
            try? self.sampler.play(noteNumber: MIDINoteNumber($0), velocity: 80, channel: midiChannel)
        }
    }
}
