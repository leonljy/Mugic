//
//  ViewController+Delegates.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 9. 26..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: InstrumentSelectionDelegate {
    func selectPanel(_ selected: PanelType) {
        switch selected {
        case .Chord:
            self.chrodPanelView?.isHidden = false
            self.pianoPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = true
        case .Melody:
            self.chrodPanelView?.isHidden = true
            self.pianoPanelView?.isHidden = false
            self.drumKitPanelView?.isHidden = true
        case .DrumKit:
            self.chrodPanelView?.isHidden = true
            self.pianoPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = false
        case .Voice:
            self.chrodPanelView?.isHidden = false
            self.pianoPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = true
        }
    }
}


//Chord Mode Extension {
extension ViewController: ChordPanelDelegate {
    
    func noteTouchDown(sender: UIButton) {
        self.noteValue = sender.tag
        self.noteString = sender.titleLabel?.text
    }
    
    func chordTouchDown(sender: UIButton) {
        guard let note = Note(rawValue: self.noteValue), let chord = Chord(rawValue: sender.tag) else {
            return
        }
        self.chordString = sender.titleLabel?.text
        self.conductor.play(root: note, chord: chord)
        self.recorder.save(root: note, chord: chord)
    }
    
    func chordTouchUpOutside(sender: UIButton) {
        self.chordString = nil
    }
    
    func chordTouchUpInside(sender: UIButton) {
        self.chordString = nil
    }
    
    func noteTouchUpInside(sender: UIButton) {
        self.noteValue = 0
        self.noteString = nil
    }
    
    func noteTouchUpOutside(sender: UIButton) {
        self.noteValue = 0
        self.noteString = nil
        
    }
}

//Melody Mode Extension
extension ViewController: PianoPanelDelegate {
    func melodyTouchDown(sender: UIButton) {
        let tag = sender.tag
        self.conductor.play(note: tag)
        self.recorder.save(note: tag)
    }
    func melodyTouchUpInside(sender: UIButton) {
    }
    func melodyTouchUpOutside(sender: UIButton) {
    }
}

//Drum Mode Extension
extension ViewController: DrumKitPanelDelegate {
    func playDrum(sender: UIButton) {
        self.conductor.playDrum(note: sender.tag)
        self.recorder.save(rhythmNote: sender.tag)
    }
    
    func touchUpInside() {
        
    }
    
    func touchUpOutside() {
        
    }
}
