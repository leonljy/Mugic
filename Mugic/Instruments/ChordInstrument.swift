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
    
    override init() {
        self.numberOfPolyphonic = 0
        super.init()
    }
    
    static func adding(_ note: Note, modifier: Modifier = .Natural, interval: Interval = .NONE, octave: Int = 0 ) -> Int {
        
        let n = note.rawValue + modifier.rawValue + interval.rawValue
        let octaveAdded = n + (OCTAVE * octave)
        return octaveAdded
    }
    
    func stop() {
//        try? self.sampler.stop()
//        let midiChannel = MIDIChannel()
//        self.noteNumbers.forEach {
////            try? self.sampler.stop(noteNumber: MIDINoteNumber($0), channel: midiChannel)
//
//        }
//        self.noteNumbers = []
    }
    
    func play(note: MIDINoteNumber) {
        let midiChannel = MIDIChannel()
        try? self.sampler.play(noteNumber: note, velocity: 80, channel: midiChannel)
    }
    
    func play(root: Note, chord: Chord) {
        let midiChannel = MIDIChannel()
        
        self.chordNotes(root: root, chord: chord).forEach {
            try? self.sampler.play(noteNumber: MIDINoteNumber($0), velocity: 80, channel: midiChannel)
        }
    }
    
    func chordNotes(root: Note, chord: Chord) -> [Int] {
        let bass = ChordInstrument.adding(root)
        let fifth = ChordInstrument.adding(root, interval: Interval.PERFECT_FIFTH)
        let third: Int
        let seventh: Int
        
        let leftHandRoot = bass - ChordInstrument.OCTAVE
        let leftHandFifth = fifth - ChordInstrument.OCTAVE
        var noteNumbers = [leftHandRoot, leftHandFifth, bass, fifth]
        
        switch chord {
        case .maj:
            third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            noteNumbers.append(third)
        case .min:
            third = ChordInstrument.adding(root, interval: Interval.MIN_TRIAD)
            noteNumbers.append(third)
        case .add2:
            third = ChordInstrument.adding(root, interval: Interval.SECOND)
            noteNumbers.append(third)
        case .sus4:
            third = ChordInstrument.adding(root, interval: Interval.PERFECT_FORTH)
            noteNumbers.append(third)
        case .seventh:
            third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            noteNumbers.append(third)
            seventh = ChordInstrument.adding(root, interval: Interval.DOMINENT_SEVENTH)
            noteNumbers.append(seventh)
        case .maj7:
            third = ChordInstrument.adding(root, interval: Interval.MAJ_TRIAD)
            noteNumbers.append(third)
            seventh = ChordInstrument.adding(root, interval: Interval.MAJ_SEVENTH)
            noteNumbers.append(seventh)
        case .min7:
            third = ChordInstrument.adding(root, interval: Interval.MIN_TRIAD)
            noteNumbers.append(third)
            seventh = ChordInstrument.adding(root, interval: Interval.DOMINENT_SEVENTH)
            noteNumbers.append(seventh)
        case .add6:
            third = ChordInstrument.adding(root, interval: Interval.SIXTH)
            noteNumbers.append(third)
        case .dim7:
            noteNumbers.removeAll()
            noteNumbers.append(bass)
            //            self.noteNumbers.insert(bass - Piano.OCTAVE)
            third = ChordInstrument.adding(root, interval: Interval.MIN_TRIAD)
            noteNumbers.append(third)
            let flatFive = ChordInstrument.adding(root, interval: Interval.FLAT_FIVE)
            noteNumbers.append(flatFive)
            seventh = ChordInstrument.adding(root, interval: Interval.SIXTH)
            noteNumbers.append(seventh)
        }
        
        return noteNumbers
    }
}
