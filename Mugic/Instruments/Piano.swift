//
//  Piano.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 6..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

class Piano: Instrument {
    
    func play(root: Note, chord: Chord, amplitude: Double = 1.0) {
        let noteNumbers: [Int]
        let bass = Instrument.adding(root)
        switch chord {
        case .maj:
            let third = Instrument.adding(root, interval: Interval.MAJ_TRIAD)
            let fifth = Instrument.adding(root, interval: Interval.PERFECT_FIFTH)
            noteNumbers = [bass, third, fifth]
        case .min:
            let third = Instrument.adding(root, interval: Interval.MIN_TRIAD)
            let fifth = Instrument.adding(root, interval: Interval.PERFECT_FIFTH)
            noteNumbers = [bass, third, fifth]
        case .sus4:
            let third = Instrument.adding(root, interval: Interval.PERFECT_FORTH)
            let fifth = Instrument.adding(root, interval: Interval.PERFECT_FIFTH)
            noteNumbers = [bass, third, fifth]
        case .seventh:
            let third = Instrument.adding(root, interval: Interval.MAJ_TRIAD)
            let fifth = Instrument.adding(root, interval: Interval.PERFECT_FIFTH)
            let seventh = Instrument.adding(root, interval: Interval.DOMINENT_SEVENTH)
            noteNumbers = [bass, third, fifth, seventh]
        case .maj7:
            let third = Instrument.adding(root, interval: Interval.MAJ_TRIAD)
            let fifth = Instrument.adding(root, interval: Interval.PERFECT_FIFTH)
            let seventh = Instrument.adding(root, interval: Interval.MAJ_SEVENTH)
            noteNumbers = [bass, third, fifth, seventh]
        case .add2:
            let third = Instrument.adding(root, interval: Interval.SECOND)
            let fifth = Instrument.adding(root, interval: Interval.PERFECT_FIFTH)
            noteNumbers = [bass, third, fifth]
        }
        
        for noteNumber in noteNumbers {
            self.instrument.play(noteNumber: MIDINoteNumber(noteNumber), velocity: 80, channel: MIDIChannel())
        }
    }
}
