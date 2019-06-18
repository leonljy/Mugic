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

class Conductor {
    static let shared: Conductor = Conductor()
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
    
    var timers: [Timer] = []
    
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
        
        do {
            try AudioKit.start()
        } catch let error as NSError {
            print(error)
        }
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
        for timer in self.timers {
            timer.invalidate()
        }
        self.timers.removeAll()
        self.isPlaying = false
    }
    
    func replay(song: Song, completionBlock: @escaping () -> Void) {
        self.isPlaying = true
        guard let tracks = song.tracks?.array as? [Track] else {
            return
        }
        var mergedEvents: [Event] = []
        for track in tracks {
            if let events = track.events?.allObjects as? [Event] {
                mergedEvents.append(contentsOf: events)
            }
        }
        
        mergedEvents.sort { (a, b) -> Bool in
            return a.time < b.time
        }
        
        self.createEventTimers(events: mergedEvents, completionBlock: completionBlock)
        
        let loop = RunLoop.current
        for timer in self.timers {
            loop.add(timer, forMode: RunLoop.Mode.default)
        }

        loop.run()
    }
    
    func createEventTimers(events: [Event], completionBlock: @escaping () -> Void) {
        guard events.count > 0 else {
            return
        }
        
        self.timers = []
        for event in events {
            let timer = Timer(timeInterval: TimeInterval(event.time) + TimeInterval(1), repeats: false) { _ in
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
            
            self.timers.append(timer)
        }
        
        guard let lastEvent = events.last else {
            return
        }
        let lastTimer = Timer(timeInterval: TimeInterval(2) + TimeInterval(lastEvent.time), repeats: false) { _ in
            completionBlock()
        }
        self.timers.append(lastTimer)
    }
    
}
