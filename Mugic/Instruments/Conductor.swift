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
        case Record
    }
    
    enum Instruments: Int {
        case Guitar = 0
        case Piano
        case Drumkit
        case Voice
        case Guitar2
    }
    
    static let shared: Conductor = Conductor()
    
    let mixer = Mixer()

    let compressor: Compressor
    
    var sequencer = Sequencer()
    
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
    
    var instruments: [Instrument] = []
    
    var currentTrack: Int = 0
    
    var song: Song? {
        didSet {
            guard let song = self.song else { return }
            guard let tracks = song.tracks?.reversed.array as? [Track] else { return }
            self.instruments = []
            tracks.forEach({
                self.addInstrument(track: $0)
            })
        }
    }
    
    init() {
        self.compressor = Compressor(self.mixer)
        let engine = AudioEngine()
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func addInstrument(track: Track) {
        let instrumentType = InstrumentType(rawValue: track.instrument)
        let instrument: Instrument
        switch instrumentType {
            case .PianoChord, .PianoMelody:
                instrument = Piano()
            case .GuitarMelody, .GuitarChord:
                instrument = Guitar()
            case .DrumKit:
                instrument = Drum()
            case .none:
                instrument = Instrument()
        }
        self.instruments.append(instrument)
        self.mixer.addInput(instrument.sampler)
    }
    
    func changeVolume(trackIndex: Int, volume: Double) {
        let instrument = self.instruments[trackIndex]
        instrument.sampler.volume = AUValue(volume)
    }
    
    func play(root: Note, chord: Chord) {
        let instrument = self.instruments[self.currentTrack]
        guard instrument.self is ChordInstrument else { return }
        (instrument as! ChordInstrument).play(root: root, chord: chord)
    }
    
    func play(note: MIDINoteNumber) {
        let instrument = self.instruments[self.currentTrack]
        guard instrument.self is ChordInstrument else { return }
        (instrument as! ChordInstrument).play(note: note)
    }
    
    func playDrum(note: Int) {
        guard let drumKit = Drum.DrumKit(rawValue: note) else {
            return
        }
        let instrument = self.instruments[self.currentTrack]
        guard instrument.self is Drum else { return }
        (instrument as! Drum).play(drumKit)
    }
    
    func stop() {
        self.sequencer.stop()
        self.sequencer.rewind()
        self.playStatus = .Stop
    }
    
    func pause() {
        self.sequencer.pause()
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
        self.sequencer.play()
        self.playStatus = .Play
    }
    
//    func endAudioKit() {
//        do {
//            try AudioKit.stop()
//        } catch let error as NSError {
//            print(error)
//        }
//    }
}


extension Conductor {
    
    func replay(withMetronome: Bool = false, song: Song, completionBlock: @escaping () -> Void) {
        guard let tracks = song.tracks?.reversed.array as? [Track] else { return }
        self.sequencer = Sequencer()
        self.completionBlock = completionBlock
        var lastTime: Double = 0
        
        for (trackIndex, track) in tracks.enumerated() {
            let sampler = self.instruments[trackIndex].sampler
            
            if track.isMuted {
                sampler.volume = 0
            } else {
                sampler.volume = AUValue(track.volume)
            }
            
            let sequencerTrack: SequencerTrack = self.sequencer.addTrack(for: sampler)

            guard let events = track.events?.allObjects else {
                return
            }

            let beat: Double = Double(song.tempo) / 60
            
            var beats: [Double] = []
            
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
                        sequencer.add(noteNumber: MIDINoteNumber(note), position: event.time * beat, duration: 2, trackIndex: trackIndex)
                    }
                    beats.append(event.time * beat)
                    lastTime = event.time > lastTime ? event.time : lastTime
                } else if $0 is MelodicEvent {
                    let event = $0 as! MelodicEvent
                    sequencer.add(noteNumber: MIDINoteNumber(Int(event.note)), position: event.time * beat, duration: 2, trackIndex: trackIndex)
                    beats.append(event.time * beat)
                    lastTime = event.time > lastTime ? event.time : lastTime
                } else if $0 is RhythmEvent {
                    let event = $0 as! RhythmEvent
                    sequencer.add(noteNumber: MIDINoteNumber(Int(event.beat)), position: event.time * beat, duration: 2, trackIndex: trackIndex)
                    beats.append(event.time * beat)
                    lastTime = event.time > lastTime ? event.time : lastTime
                }
            }
            if let last = beats.sorted().last {
                sequencerTrack.length = last + 1
                sequencerTrack.loopEnabled = false
                guard let targetNode = sequencerTrack.targetNode else { return }
                self.mixer.addInput(targetNode)
            }
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
        self.sequencer.play()
        self.sequencer.tempo = Double(song.tempo)
    }
}


