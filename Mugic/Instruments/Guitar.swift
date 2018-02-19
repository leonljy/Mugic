//
//  Guitar.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 6..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

class Guitar: ChordInstrument {
    
    init(midifileName: String = "Acoustic Guitars JNv2.4") {
        super.init()
        super.noteNumbers = []
        do {
            self.midiFileName = midifileName
            self.samplers = [self.rootSampler, self.thirdSampler, self.fifthSampler, self.seventhSampler]
            for sampler in super.samplers {
                try sampler.loadMelodicSoundFont(self.midiFileName, preset: 0)
            }
            
        } catch  {
            print("File not found")
        }
    }
    
    func play(root: Note, chord: Chord, amplitude: Double = 1.0) {
        self.stop()
        
        let bass = ChordInstrument.adding(root)
        switch chord {
        case .maj:
            let third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            let fifth = ChordInstrument.adding(root, interval: Interval.PERFECT_FIFTH)
            self.noteNumbers = [bass, third, fifth]
        case .min:
            let third = ChordInstrument.adding(root, interval: Interval.MIN_TRIAD)
            let fifth = ChordInstrument.adding(root, interval: Interval.PERFECT_FIFTH)
            self.noteNumbers = [bass, third, fifth]
        case .sus4:
            let third = ChordInstrument.adding(root, interval: Interval.PERFECT_FORTH)
            let fifth = ChordInstrument.adding(root, interval: Interval.PERFECT_FIFTH)
            self.noteNumbers = [bass, third, fifth]
        case .seventh:
            let third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            let fifth = ChordInstrument.adding(root, interval: Interval.PERFECT_FIFTH)
            let seventh = ChordInstrument.adding(root, interval: Interval.DOMINENT_SEVENTH)
            self.noteNumbers = [bass, third, fifth, seventh]
        case .maj7:
            let third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            let fifth = ChordInstrument.adding(root, interval: Interval.PERFECT_FIFTH)
            let seventh = ChordInstrument.adding(root, interval: Interval.MAJ_SEVENTH)
            self.noteNumbers = [bass, third, fifth, seventh]
        case .add2:
            let third = ChordInstrument.adding(root, interval: Interval.SECOND)
            let fifth = ChordInstrument.adding(root, interval: Interval.PERFECT_FIFTH)
            self.noteNumbers = [bass, third, fifth]
        }
        
        
        let midiChannel = MIDIChannel()
        for (index, noteNumber) in self.noteNumbers.enumerated() {
            self.samplers[index].play(noteNumber: MIDINoteNumber(noteNumber), velocity: 80, channel: midiChannel)
        }
    }
}
