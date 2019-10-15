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
        self.timers = []
        self.isPlaying = false
    }
}


extension Conductor {
    func replay(withMetronome: Bool = false, song: Song, completionBlock: @escaping () -> Void) {
        self.isPlaying = true
        
        self.addCountIn(song: song)
        if withMetronome {
            self.addMetronomeBeats(song: song)
        }
        
        self.addEventTimers(song: song, completionBlock: completionBlock)
        let loop = RunLoop.current
        for timer in self.timers {
            loop.add(timer, forMode: RunLoop.Mode.default)
        }
        
        loop.run()
    }
    
    func addCountIn(song: Song) {
        let countInNumber = song.countInNumber()
        print("BeatInterval: \(song.beatInterval)")
        let startDate = Date()
        let runloop = RunLoop.current
        for index in 0 ..< countInNumber {
            let timeInterval = song.beatInterval * Double(index)
            let timer = Timer(timeInterval: timeInterval, repeats: false) { (timer) in
                print("Beat \(index + 1): \(Date().timeIntervalSince(startDate))")
                self.playDrum(note: DrumKit.RimShot.rawValue)
            }
            runloop.add(timer, forMode: .default)
            self.timers.append(timer)
        }
    }
    
    func addMetronomeBeats(song: Song) {
        let countInTime = song.countInTime
        print("Start Metronome")
        let startDate = Date()
        let runloop = RunLoop.current
        let fireTime = Date(timeIntervalSinceNow: countInTime)
        let timer = Timer(fire: fireTime, interval: song.beatInterval, repeats: true) { (timer) in
            print("Beat: \(Date().timeIntervalSince(startDate))")
            self.playDrum(note: DrumKit.HihatClosed.rawValue)
        }
        runloop.add(timer, forMode: .default)
        self.timers.append(timer)
    }
    
    func sortedEventsIn(song: Song) -> [Event] {
        guard let tracks = song.tracks?.array as? [Track] else {
            return []
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
        
        return mergedEvents
    }
    
    func addEventTimers(song: Song, completionBlock: @escaping () -> Void) {
        let events = self.sortedEventsIn(song: song)
        let countInTime = song.countInTime
        guard events.count > 0 else {
            return
        }
        
        for event in events {
            let timer = self.eventTimer(event: event, countInTime: countInTime)
            self.timers.append(timer)
        }
        
        guard let lastEvent = events.last else {
            return
        }
        let lastTimer = Timer(timeInterval: TimeInterval(countInTime) + TimeInterval(lastEvent.time), repeats: false) { _ in
            completionBlock()
        }
        self.timers.append(lastTimer)
    }
    
    func eventTimer(event: Event, countInTime: TimeInterval) -> Timer {
        print(event.time)
        let timeInterval = TimeInterval(event.time) + TimeInterval(countInTime)
        print(timeInterval)
        return Timer(timeInterval: timeInterval, repeats: false) { _ in
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
    }
}


