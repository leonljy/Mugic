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
    
    func replay(events: [Event]) {
        self.replay(events: events, currentTime: 0)
    }
    
    private func replay(events: [Event], currentTime: TimeInterval) {
        guard events.count > 0 else {
            return
        }
        var events = events
        let event = events.removeFirst()
        Timer.scheduledTimer(withTimeInterval: event.time - currentTime, repeats: false) { (timer) in
            self.piano.play(root: event.root, chord: event.chord)
            self.replay(events: events, currentTime: event.time)
        }
    }
}
