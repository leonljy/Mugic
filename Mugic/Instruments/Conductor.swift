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
    let mixer = AKMixer()
    let piano: Piano
    let guitar: Guitar
    
    init() {
        self.piano = Piano()
        self.guitar = Guitar()
        self.piano.samplers.forEach {
          self.mixer.connect(input: $0)
        }
        self.guitar.samplers.forEach {
          self.mixer.connect(input: $0)
        }
        
        AudioKit.output = self.mixer
        AudioKit.start()
    }
    
    func play(root: Note, chord: Chord) {
        self.piano.play(root: root, chord: chord)
//        self.guitar.play(root: root, chord: chord)
    }
}
