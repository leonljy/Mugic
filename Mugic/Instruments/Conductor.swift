//
//  Conductor.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 6..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit


struct Conductor {
    let piano: Piano
    let mixer: AKMixer
    init() {
        self.piano = Piano()
        self.mixer = AKMixer(self.piano.instrument)
        AudioKit.output = self.mixer
        AudioKit.start()
    }
    
    func play() {
        
    }
}
