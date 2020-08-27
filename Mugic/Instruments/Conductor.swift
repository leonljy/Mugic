//
//  Conductor.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 6..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit


class Conductor {
    
    enum PlayStatus {
        case Stop
        case Play
        case Pause
    }
    
    enum Instruments: Int {
        case Guitar = 0
        case Piano
        case Drumkit
        case Voice
        case Guitar2
    }
    
    static let shared: Conductor = Conductor()
    let mixer = AKMixer()
    let piano: Piano
    let guitar: Guitar
    let drum: Drum
    
    let metronome = AKMetronome()
    
    var sequencer: AKSequencer?
    
    var completionTimer: Timer = Timer()
    
    var startDate: Date = Date()
    var remainSongLength: Double = 0
    var completionBlock: () -> Void = {}
    
    var playing = PlayStatus.Stop
    var playStatus: PlayStatus {
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
        
        self.mixer.connect(input: self.piano.sampler)
        self.mixer.connect(input: self.guitar.sampler)
        self.mixer.connect(input: self.drum.sampler)
        
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
    
    func play(instrument: InstrumentType, note: MIDINoteNumber, amplitude: Double = 1.0) {
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
        guard let drumKit = Drum.DrumKit(rawValue: note) else {
            return
        }
        self.drum.play(drumKit)
    }
    
    func stop() {
        self.sequencer?.stop()
        self.sequencer?.rewind()
        self.playStatus = .Stop
    }
    
    func pause() {
        self.sequencer?.pause()
        self.playStatus = .Pause
        self.completionTimer.invalidate()
        self.remainSongLength -= Double(Date().timeIntervalSince(self.startDate))
    }
    
    func replay() {
        self.startDate = Date()
        let completionDate = Calendar.current.date(byAdding: .second, value: Int(self.remainSongLength) + 1, to: self.startDate)!
        self.completionTimer = Timer(fire: completionDate, interval: 0, repeats: false, block: { (timer) in
            self.completionBlock()
        })
        DispatchQueue.main.async {
            RunLoop.current.add(self.completionTimer, forMode: .default)
        }
        self.sequencer?.play()
        self.playStatus = .Play
    }
}


extension Conductor {
    
    func replay(withMetronome: Bool = false, song: Song, completionBlock: @escaping () -> Void) {
        guard let tracks = song.tracks?.array as? [Track] else {
            return
        }
        let sequencer = AKSequencer()
        self.sequencer = sequencer
        self.completionBlock = completionBlock
        var lastTime: Double = 0
        tracks.forEach {
            guard let instrument = InstrumentType(rawValue: $0.instrument) else {
                return
            }
            let track: AKSequencerTrack
            switch instrument {
            case .PianoChord, .PianoMelody:
                track = sequencer.addTrack(for: self.piano.sampler)
            case .GuitarMelody, .GuitarChord:
                track = sequencer.addTrack(for: self.guitar.sampler)
            case .DrumKit:
                track = sequencer.addTrack(for: self.drum.sampler)
            }

            guard let events = $0.events?.allObjects else {
                return
            }

            let beat: Double = Double(song.tempo) / 60
            var beats: [Double] = []
            events.forEach {
                if $0 is ChordEvent {
                    let event = $0 as! ChordEvent
                    print(event.time)
                    guard let note = Note(rawValue: Int(event.baseNote)) else {
                        return
                    }
                    guard let chord = Chord(rawValue: Int(event.chord)) else {
                        return
                    }
                    let notes = ChordInstrument().chordNotes(root: note, chord: chord)
                    notes.forEach { note in
                        track.add(noteNumber: MIDINoteNumber(note), position: event.time * beat, duration: 3)
                    }
                    beats.append(event.time * beat)
                    lastTime = event.time > lastTime ? event.time : lastTime
                } else if $0 is MelodicEvent {
                    let event = $0 as! MelodicEvent
                    track.add(noteNumber: MIDINoteNumber(Int(event.note)), position: event.time * beat, duration: 3)
                    beats.append(event.time * beat)
                    lastTime = event.time > lastTime ? event.time : lastTime
                } else if $0 is RhythmEvent {
                    let event = $0 as! RhythmEvent
                    track.add(noteNumber: MIDINoteNumber(Int(event.beat)), position: event.time * beat, duration: 3)
                    beats.append(event.time * beat)
                    lastTime = event.time > lastTime ? event.time : lastTime
                }
            }
            guard let last = beats.sorted().last else {
                return
            }
            track.length = last + 1
            track.loopEnabled = false
            track >>> self.mixer
        }
        self.playStatus = .Play
        
        self.remainSongLength = lastTime
        self.startDate = Date()
        let completionDate = Calendar.current.date(byAdding: .second, value: Int(self.remainSongLength) + 1, to: self.startDate)!
        self.completionTimer = Timer(fire: completionDate, interval: 0, repeats: false, block: { (timer) in
            self.completionBlock()
        })
        DispatchQueue.main.async {
            RunLoop.current.add(self.completionTimer, forMode: .default)
        }
        sequencer.play()
        sequencer.tempo = Double(song.tempo)
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
}


