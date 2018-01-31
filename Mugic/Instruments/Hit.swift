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
    
    init(bass: Note, chord: Chord, amplitude: Double = 1.0) {
        let frequencies: [Double]
        switch chord {
            case .maj:
                let bassFrequency = Instrument.frequency(bass)
                let thirdFrequency = Instrument.frequency(bass, adding: Interval.MAJ_TRIAD)
                let fifthFrequency = Instrument.frequency(bass, adding: Interval.PERFECT_FIFTH)
                frequencies = [bassFrequency, thirdFrequency, fifthFrequency]
            case .min:
                let bassFrequency = Instrument.frequency(bass)
                let thirdFrequency = Instrument.frequency(bass, adding: Interval.MIN_TRIAD)
                let fifthFrequency = Instrument.frequency(bass, adding: Interval.PERFECT_FIFTH)
                frequencies = [bassFrequency, thirdFrequency, fifthFrequency]
            case .sus4:
                let bassFrequency = Instrument.frequency(bass)
                let thirdFrequency = Instrument.frequency(bass, adding: Interval.PERFECT_FORTH)
                let fifthFrequency = Instrument.frequency(bass, adding: Interval.PERFECT_FIFTH)
                frequencies = [bassFrequency, thirdFrequency, fifthFrequency]
            case .seventh:
                let bassFrequency = Instrument.frequency(bass)
                let thirdFrequency = Instrument.frequency(bass, adding: Interval.MAJ_TRIAD)
                let fifthFrequency = Instrument.frequency(bass, adding: Interval.PERFECT_FIFTH)
                let seventhFrequency = Instrument.frequency(bass, adding: Interval.DOMINENT_SEVENTH)
                frequencies = [bassFrequency, thirdFrequency, fifthFrequency, seventhFrequency]
            case .maj7:
                let bassFrequency = Instrument.frequency(bass)
                let thirdFrequency = Instrument.frequency(bass, adding: Interval.MAJ_TRIAD)
                let fifthFrequency = Instrument.frequency(bass, adding: Interval.PERFECT_FIFTH)
                let seventhFrequency = Instrument.frequency(bass, adding: Interval.MAJ_SEVENTH)
                frequencies = [bassFrequency, thirdFrequency, fifthFrequency, seventhFrequency]
            case .add2:
                let bassFrequency = Instrument.frequency(bass)
                let thirdFrequency = Instrument.frequency(bass, adding: Interval.SECOND)
                let fifthFrequency = Instrument.frequency(bass, adding: Interval.PERFECT_FIFTH)
                frequencies = [bassFrequency, thirdFrequency, fifthFrequency]
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
