//
//  Drum.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 3. 21..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

enum DrumKit: Int {
    case Crash = 0
    case Ride
    case Kick
    case RimShot
    case TomHi
    case TomMid
    case TomLow
    case Snare
    case HihatOpened
    case HihatClosed
}

class Drum: BeatInstrument {
    
    let kick = AKAppleSampler()
    let snare = AKAppleSampler()
    let rimShot = AKAppleSampler()
    let ride = AKAppleSampler()
    let hihatOpened = AKAppleSampler()
    let hihatClosed = AKAppleSampler()
    let crash = AKAppleSampler()
    let tomHi = AKAppleSampler()
    let tomMid = AKAppleSampler()
    let tomLow = AKAppleSampler()
    
    let drumkit: [AKAppleSampler]
    
    override init() {
        try? self.kick.loadWav("Sounds/Drum/Kick")
        try? self.snare.loadWav("Sounds/Drum/Snare")
        try? self.rimShot.loadWav("Sounds/Drum/RimShot")
        try? self.ride.loadWav("Sounds/Drum/Ride")
        try? self.hihatOpened.loadWav("Sounds/Drum/HatsOpen")
        try? self.hihatClosed.loadWav("Sounds/Drum/HatsClosed")
        try? self.crash.loadWav("Sounds/Drum/Crash")
        try? self.tomHi.loadWav("Sounds/Drum/TomHi")
        try? self.tomMid.loadWav("Sounds/Drum/TomMid")
        try? self.tomLow.loadWav("Sounds/Drum/TomLow")
        
        self.drumkit = [self.kick, self.snare, self.rimShot, self.ride, self.hihatClosed, self.hihatOpened, self.crash, self.tomLow, self.tomMid, self.tomHi]
        super.init()
        
        do {
            try self.sampler.loadAudioFiles([
                AKAudioFile(readFileName: "Sounds/Test/bass_drum_C1.wav"),
                AKAudioFile(readFileName: "Sounds/Test/snare_D1.wav")
            ])
        } catch {
            print(error)
        }
    }
    
    func play(_ drumkit: DrumKit) {
        switch drumkit {
            case .Kick:
                try? self.kick.play()
            case .Snare:
                try? self.snare.play()
            case .RimShot:
                try? self.rimShot.play()
            case .Ride:
                try? self.ride.play()
            case .HihatClosed:
                try? self.hihatClosed.play()
            case .HihatOpened:
                try? self.hihatOpened.play()
            case .Crash:
                try? self.crash.play()
            case .TomHi:
                try? self.tomHi.play()
            case .TomMid:
                try? self.tomMid.play()
            case .TomLow:
                try? self.tomLow.play()
        }
    }
    
}
