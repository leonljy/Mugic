//
//  BeatInstrument.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/06/20.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

class BeatInstrument: Instrument {
    var beats: Set<Int>

    override init() {
        self.beats = []

        super.init()
    }
    
    
    func stop() {
        let midiChannel = MIDIChannel()
        for (index, noteNumber) in self.beats.enumerated() {
            try? self.samplers[index].stop(noteNumber: MIDINoteNumber(noteNumber), channel: midiChannel)
        }
        self.beats = []
    }
    
    func play() {
        let midiChannel = MIDIChannel()
        for (index, noteNumber) in self.beats.enumerated() {
            try? self.samplers[index].play(noteNumber: MIDINoteNumber(noteNumber), velocity: 80, channel: midiChannel)
        }
    }
}

