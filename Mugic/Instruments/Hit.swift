//
//  Piano.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 1. 14..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

struct Hit {
    let attackDuration: Double = 0.0
    let decayDuration: Double = 0.2
    let sustainLevel: Double = 0.0
    let releaseDuration: Double = 0.0
    let envelope: AKAmplitudeEnvelope
    
    init(root: Note, chord: Chord, amplitude: Double = 1.0) {
        let frequencies: [Double]
        let lowerBass = Instrument.frequency(root, octave: -1)
        let bass = Instrument.frequency(root)
        switch chord {
            case .maj:
                let third = Instrument.frequency(root, adding: Interval.MAJ_TRIAD)
                let fifth = Instrument.frequency(root, adding: Interval.PERFECT_FIFTH)
                frequencies = [lowerBass, bass, third, fifth]
            case .min:
                let third = Instrument.frequency(root, adding: Interval.MIN_TRIAD)
                let fifth = Instrument.frequency(root, adding: Interval.PERFECT_FIFTH)
                frequencies = [lowerBass, bass, third, fifth]
            case .sus4:
                let third = Instrument.frequency(root, adding: Interval.PERFECT_FORTH)
                let fifth = Instrument.frequency(root, adding: Interval.PERFECT_FIFTH)
                frequencies = [lowerBass, bass, third, fifth]
            case .seventh:
                let third = Instrument.frequency(root, adding: Interval.MAJ_TRIAD)
                let fifth = Instrument.frequency(root, adding: Interval.PERFECT_FIFTH)
                let seventh = Instrument.frequency(root, adding: Interval.DOMINENT_SEVENTH)
                frequencies = [lowerBass, bass, third, fifth, seventh]
            case .maj7:
                let third = Instrument.frequency(root, adding: Interval.MAJ_TRIAD)
                let fifth = Instrument.frequency(root, adding: Interval.PERFECT_FIFTH)
                let seventh = Instrument.frequency(root, adding: Interval.MAJ_SEVENTH)
                frequencies = [lowerBass, bass, third, fifth, seventh]
            case .add2:
                let third = Instrument.frequency(root, adding: Interval.SECOND)
                let fifth = Instrument.frequency(root, adding: Interval.PERFECT_FIFTH)
                frequencies = [lowerBass, bass, third, fifth]
        }
        
        
        let mixer = AKMixer()
        
        for frequency in frequencies {
            let oscillator = AKOscillator()
            oscillator.frequency = frequency
            oscillator.amplitude = amplitude
            oscillator.start()
            mixer.connect(input: oscillator)
        }
        
        self.envelope = AKAmplitudeEnvelope(mixer)
        self.envelope.attackDuration = self.attackDuration
        self.envelope.decayDuration = self.decayDuration
        self.envelope.sustainLevel = self.sustainLevel
        self.envelope.releaseDuration = self.releaseDuration
        
        AudioKit.output = self.envelope

    }
    
    func play() {
        AudioKit.start()
        self.envelope.start()
    }
    
    func stop() {
        self.envelope.stop()
        AudioKit.stop()
    }
    
}
