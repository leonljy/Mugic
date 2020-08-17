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
        try? self.sampler.stop()
//        let midiChannel = MIDIChannel()
//        self.beats.forEach {
//            try? self.sampler.stop(noteNumber: MIDINoteNumber($0), channel: midiChannel)
//        }
//        self.beats = []
    }
    
    func play() {
        let midiChannel = MIDIChannel()
        self.beats.forEach {
            try? self.sampler.play(noteNumber: MIDINoteNumber($0), velocity: 80, channel: midiChannel)
        }
    }
}

