//
//  Drum.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 3. 21..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit



class Drum: BeatInstrument {

    enum DrumKit: Int, CaseIterable {
        case Kick = 24
        case RimShot
        case TomLow
        case TomMid
        case TomHi
        case Snare
        case Crash
        case Ride
        case HihatClosed
        case HihatOpened
    }
    
    override init() {
        super.init()
        self.sampler = AKAppleSampler()
        var audioFiles: [AKAudioFile] = []

        Drum.DrumKit.allCases.forEach {
            do {
                let audioFile = try AKAudioFile(readFileName: $0.fileName)
                audioFiles.append(audioFile)
            } catch {
                print(error.localizedDescription)
            }
        }
        do {
            try self.sampler.loadAudioFiles(audioFiles)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func play(_ drumkit: DrumKit) {
        try? self.sampler.play(noteNumber: MIDINoteNumber(drumkit.rawValue))
    }
}

extension Drum.DrumKit {
    var fileName: String {
        return "Sounds/Drum/\(self.kitName)_\(self.noteString).wav"
    }
    
    var kitName: String {
        switch self {
            case .Kick:
                return "Kick"
            case .RimShot:
                return "RimShot"
            case .TomHi:
                return "TomHi"
            case .TomMid:
                return "TomMid"
            case .TomLow:
                return "TomLow"
            case .Snare:
                return "Snare"
            case .Crash:
                return "Crash"
            case .Ride:
                return "Ride"
            case .HihatClosed:
                return "HihatClosed"
            case .HihatOpened:
                return "HihatOpened"
        }
    }
    
    var noteString: String {
        switch self {
            case .Kick:
                return "C1"
            case .RimShot:
                return "C#1"
            case .TomLow:
                return "D1"
            case .TomMid:
                return "D#1"
            case .TomHi:
                return "E1"
            case .Snare:
                return "F1"
            case .Crash:
                return "F#1"
            case .Ride:
                return "G1"
            case .HihatClosed:
                return "G#1"
            case .HihatOpened:
                return "A1"
        }
    }
}
