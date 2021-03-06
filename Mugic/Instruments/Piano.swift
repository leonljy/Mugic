//
//  Piano.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 6..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

class Piano: ChordInstrument {
    
    init(midifileName: String = "Sounds/Sampler Instruments/sawPiano1") {
        super.init()
        self.noteNumbers = []
        do {
            self.midiFileName = midifileName
            self.numberOfPolyphonic = 10
            for _ in 0 ..< self.numberOfPolyphonic {
                let sampler = AKAppleSampler()
                self.samplers.append(sampler)
            }
            
            for sampler in super.samplers {
                try sampler.loadEXS24(self.midiFileName)
            }
            
        } catch  {
            print("File not found")
        }
    }
    
    
    func play(note: Int, amplitude: Double = 1.0) {
        self.stop()
        self.noteNumbers.insert(note)
        self.play()
    }
    
    func play(root: Note, chord: Chord, amplitude: Double = 1.0) {
        self.stop()
        
        let bass = ChordInstrument.adding(root)
        let fifth = ChordInstrument.adding(root, interval: Interval.PERFECT_FIFTH)
        let third: Int
        let seventh: Int
        
        let leftHandRoot = bass - ChordInstrument.OCTAVE
        let leftHandFifth = fifth - ChordInstrument.OCTAVE
        self.noteNumbers = [leftHandRoot, leftHandFifth, bass, fifth]
        switch chord {
        case .maj:
            third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            self.noteNumbers.insert(third)
        case .min:
            third = ChordInstrument.adding(root, interval: Interval.MIN_TRIAD)
            self.noteNumbers.insert(third)
        case .add2:
            third = ChordInstrument.adding(root, interval: Interval.SECOND)
            self.noteNumbers.insert(third)
        case .sus4:
            third = ChordInstrument.adding(root, interval: Interval.PERFECT_FORTH)
            self.noteNumbers.insert(third)
        case .seventh:
            third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            self.noteNumbers.insert(third)
            seventh = ChordInstrument.adding(root, interval: Interval.DOMINENT_SEVENTH)
            self.noteNumbers.insert(seventh)
        case .maj7:
            third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            self.noteNumbers.insert(third)
            seventh = ChordInstrument.adding(root, interval: Interval.MAJ_SEVENTH)
            self.noteNumbers.insert(seventh)
        case .min7:
            third = ChordInstrument.adding(root, interval: Interval.MIN_TRIAD)
            self.noteNumbers.insert(third)
            seventh = ChordInstrument.adding(root, interval: Interval.DOMINENT_SEVENTH)
            self.noteNumbers.insert(seventh)
        case .add6:
            third = ChordInstrument.adding(root, interval: Interval.SIXTH)
            self.noteNumbers.insert(third)
        case .dim7:
            self.noteNumbers.removeAll()
            self.noteNumbers.insert(bass)
            third = ChordInstrument.adding(root, interval: Interval.MIN_TRIAD)
            self.noteNumbers.insert(third)
            let flatFive = ChordInstrument.adding(root, interval: Interval.FLAT_FIVE)
            self.noteNumbers.insert(flatFive)
            seventh = ChordInstrument.adding(root, interval: Interval.SIXTH)
            self.noteNumbers.insert(seventh)
        }
        
        for noteNumber in self.noteNumbers {
            if noteNumber > Note.G.rawValue {
                self.noteNumbers.remove(noteNumber)
                self.noteNumbers.insert(noteNumber - Piano.OCTAVE)
            }
        }
        self.play()
        
    }
}
