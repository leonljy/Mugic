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
    case Guitar2
}

class Conductor {
    static let shared: Conductor = Conductor()
    let mixer = AKMixer()
    let piano: Piano
    let guitar: Guitar
    let drum: Drum
    var tracks: [Track]
    
    let metronome = AKMetronome()
    
    let sequencer = AKSequencer()
    
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
        self.tracks = []
        
        self.mixer.connect(input: self.piano.sampler)
        self.mixer.connect(input: self.guitar.sampler)
        self.mixer.connect(input: self.drum.sampler)
//        self.drum.drumkit.forEach {
//            self.mixer.connect(input: $0)
//        }
        
        AudioKit.output = self.mixer
        
        self.metronome.frequency1 = 2000
        self.metronome.frequency2 = 1000
        
        do {
            try AudioKit.start()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func play(instrument: InstrumentType, root: Note, chord: Chord, amplitude: Double = 1.0) {
        switch instrument {
        case .PianoChord:
            self.piano.sampler.volume = amplitude
            self.piano.play(root: root, chord: chord)
        case .GuitarChord:
            self.guitar.sampler.volume = amplitude
            self.guitar.play(root: root, chord: chord)
        default:
            return
        }
    }
    
    func play(instrument: InstrumentType, note: Note, amplitude: Double = 1.0) {
        switch instrument {
        case .PianoMelody:
            self.piano.sampler.volume = amplitude
            self.piano.play(note: note)
        case .GuitarMelody:
            self.guitar.sampler.volume = amplitude
            self.guitar.play(note: note)
        default:
            return
        }
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
        guard let tracks = song.tracks?.array as? [Track] else {
            return
        }
        
        tracks.forEach {
            guard let instrument = InstrumentType(rawValue: $0.instrument) else {
                return
            }
            let track: AKSequencerTrack
            switch instrument {
            case .PianoChord, .PianoMelody:
                track = self.sequencer.addTrack(for: self.piano.sampler)
            case .GuitarMelody, .GuitarChord:
                track = self.sequencer.addTrack(for: self.guitar.sampler)
            case .DrumKit:
                track = self.sequencer.addTrack(for: self.drum.sampler)
            }
            
            guard let events = $0.events?.allObjects else {
                return
            }
            
            events.forEach {
                if $0 is ChordEvent {
                    let event = $0 as! ChordEvent
                    guard let note = Note(rawValue: Int(event.baseNote)) else {
                        return
                    }
                    guard let chord = Chord(rawValue: Int(event.chord)) else {
                        return
                    }
                    let notes = ChordInstrument().chordNotes(root: note, chord: chord)
                    notes.forEach { note in
                        track.add(noteNumber: MIDINoteNumber(note), position: event.time, duration: 1)
                    }
                } else if $0 is MelodicEvent {
                    let event = $0 as! MelodicEvent
                    track.add(noteNumber: MIDINoteNumber(Int(event.note)), position: event.time, duration: 1)
                } else if $0 is RhythmEvent {
                    let event = $0 as! RhythmEvent
                    Int(event.beat)
                }
            }
        }
//        let track = self.sequencer.addTrack(for: self.piano.sampler)
//        track.add(noteNumber: MIDINoteNumber(Note.C.rawValue), position: 1, duration: 1)
//        track.add(noteNumber: MIDINoteNumber(Note.E.rawValue), position: 1, duration: 1)
//        track.add(noteNumber: MIDINoteNumber(Note.G.rawValue), position: 1, duration: 1)
//        track.add(noteNumber: MIDINoteNumber(Note.D.rawValue), position: 2, duration: 1)
//        track.add(noteNumber: MIDINoteNumber(Note.F.rawValue), position: 2, duration: 1)
//        track.add(noteNumber: MIDINoteNumber(Note.A.rawValue), position: 2, duration: 1)
//        self.sequencer.tempo = 120
////        track.length = 4.0
//        track.loopEnabled = false
//        track >>> self.mixer
//        self.sequencer.play()
    }
    
    func playMetronomeBeats(song: Song) {
        self.metronome.subdivision = song.subdivision()
        self.metronome.tempo = Double(song.tempo)
        self.metronome.start()
    }
    
    func stopMetronomeBeats() {
        self.metronome.stop()
        self.metronome.reset()
    }
    
//    func addEventTimers(song: Song, completionBlock: @escaping () -> Void) {
//        let events = self.sortedEventsIn(song: song)
//        let countInTime = song.countInTime
//        guard events.count > 0 else {
//            return
//        }
//
//        for event in events {
//            let timer = self.eventTimer(event: event, countInTime: countInTime)
//            self.timers.append(timer)
//        }
//
//        guard let lastEvent = events.last else {
//            return
//        }
//        let lastTimer = Timer(timeInterval: TimeInterval(countInTime) + TimeInterval(lastEvent.time), repeats: false) { _ in
//            completionBlock()
//        }
//        self.timers.append(lastTimer)
//    }
//
//    func eventTimer(event: Event, countInTime: TimeInterval) -> Timer {
//        print(event.time)
//        let timeInterval = TimeInterval(event.time) + TimeInterval(countInTime)
//        print(timeInterval)
//        return Timer(timeInterval: timeInterval, repeats: false) { _ in
//            if event is ChordEvent {
//                let chordEvent = event as! ChordEvent
//                guard let note = Note(rawValue: Int(chordEvent.baseNote)), let chord = Chord(rawValue: Int(chordEvent.chord)) else {
//                    return
//                }
////                self.play(root: note, chord: chord)
//            } else if event is MelodicEvent {
//                let melodicEvent = event as! MelodicEvent
////                self.play(note: Int(melodicEvent.note))
//            } else if event is RhythmEvent {
//                let rhythmEvent = event as! RhythmEvent
//                self.playDrum(note: Int(rhythmEvent.beat))
//            }
//        }
//    }
}


