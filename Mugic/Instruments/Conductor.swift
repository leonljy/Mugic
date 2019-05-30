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
    var playing = false
    var isPlaying: Bool {
        get {
            return self.playing
        }
        
        set {
            self.playing = newValue
        }
    }
    
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
    
    func stop() {
        try? AudioKit.stop()
    }
    
    func eventTimers(events: [Event]) -> [Timer] {
        guard events.count > 0 else {
            return []
        }
        
        let now = Date()
        var timers: [Timer] = []
        for event in events {
            let fireDate = now.addingTimeInterval(TimeInterval(event.time) + TimeInterval(1))
            let timer = Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
                print(Date())
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
            }
            
            timers.append(timer)
        }
        
        return timers
    }
    
}
