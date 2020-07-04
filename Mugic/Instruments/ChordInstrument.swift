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
        for (index, noteNumber) in self.noteNumbers.enumerated() {
            try? self.samplers[index].stop(noteNumber: MIDINoteNumber(noteNumber), channel: midiChannel)
        }
        self.noteNumbers = []
    }
    
    func play() {
        let midiChannel = MIDIChannel()
        for (index, noteNumber) in self.noteNumbers.enumerated() {
            guard index < self.numberOfPolyphonic else {
                return
            }
            try? self.samplers[index].play(noteNumber: MIDINoteNumber(noteNumber), velocity: 80, channel: midiChannel)
        }
    }
}
