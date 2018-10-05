//
//  Conductor.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 6..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

enum Instruments: Int {
    case Guitar = 0
    case Piano
    case Drumkit
    case Voice
}

struct Conductor {
    let mixer = AKMixer()
    let piano: Piano
    let guitar: Guitar
    let drum: Drum
    
    
    init() {
        self.piano = Piano()
        self.guitar = Guitar()
        self.drum = Drum()
        
        self.piano.samplers.forEach {
            self.mixer.connect(input: $0)
        }
        self.guitar.samplers.forEach {
            self.mixer.connect(input: $0)
        }
        
        self.drum.drumkit.forEach {
            self.mixer.connect(input: $0)
        }
        
        AudioKit.output = self.mixer
        try? AudioKit.start()
    }
    
    func play(root: Note, chord: Chord) {
        self.guitar.play(root: root, chord: chord)
    }
    
    func play(note: Int) {
        self.piano.play(note: note)
    }
    
    func playDrum(note: Int) {
        guard let drumkit = DrumKit(rawValue: note) else {
            return
        }
        
        self.drum.play(drumkit)
        
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
            if event is ChordEvent {
                let chordEvent = event as! ChordEvent
                guard let note = Note(rawValue: Int(chordEvent.baseNote)), let chord = Chord(rawValue: Int(chordEvent.chord)) else {
                    return
                }
                self.play(root: note, chord: chord)
            } else if event is MelodicEvent {
                let melodicEvent = event as! MelodicEvent
                self.play(note: Int(melodicEvent.note))
            } else if event is RhythmEvent {
                let rhythmEvent = event as! RhythmEvent
                self.playDrum(note: Int(rhythmEvent.beat))
            }

            self.replay(events: events, currentTime: event.time)
        }
    }
    
    
}
