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
    let releaseDuration: Double = 0.3
    let envelope: AKAmplitudeEnvelope
    
    init(bass: BassCode, detail: DetailCode, amplitude: Double) {
        let frequencies = [BassCode.C.rawValue, BassCode.E.rawValue, BassCode.G.rawValue]
        
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
        envelope.start()
    }
    
    func stop() {
        self.envelope.stop()
        AudioKit.stop()
    }
    
}
