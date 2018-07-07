//
//  PianoPanel.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 5. 12..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

class PianoPanelOneOctaveView: UIStackView {
    
}

protocol PianoPanelDelegate {
    func melodyTouchDown(sender: UIButton)
    func melodyTouchUpInside(sender: UIButton)
    func melodyTouchUpOutside(sender: UIButton)
}


class PianoPanelView: UIView {
    @IBOutlet weak var lowOctave: PianoPanelOneOctaveView!
    @IBOutlet weak var midOctave: PianoPanelOneOctaveView!
    @IBOutlet weak var highOctave: PianoPanelOneOctaveView!
    var delegate: PianoPanelDelegate?
    
    var nomalColor: UIColor?
    
    class func instanceFromNib() -> PianoPanelView? {
        guard let instance = UINib(nibName: "PianokeyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? PianoPanelView else {
            return nil
        }
        return instance
    }
    
    @IBAction func melodyTouchDown(_ sender: UIButton) {
        self.delegate?.melodyTouchDown(sender: sender)
        self.nomalColor = sender.backgroundColor
        sender.backgroundColor = UIColor.chordHighlightedBackground
    }
    
    @IBAction func melodyTouchUpInside(_ sender: UIButton) {
        self.delegate?.melodyTouchUpInside(sender: sender)
        sender.backgroundColor = self.nomalColor
    }
    @IBAction func melodyTouchUpOutside(_ sender: UIButton) {
        self.delegate?.melodyTouchUpOutside(sender: sender)
        sender.backgroundColor = self.nomalColor
    }
    
}


protocol ChordPanelDelegate {
    func noteTouchDown(sender: UIButton)
    func noteTouchUpInside(sender: UIButton)
    func noteTouchUpOutside(sender: UIButton)
    func chordTouchDown(sender: UIButton)
    func chordTouchUpInside(sender: UIButton)
    func chordTouchUpOutside(sender: UIButton)
}

class ChordPanelView: UIView {
    var delegate: ChordPanelDelegate?
    
    class func instanceFromNib() -> ChordPanelView? {
        guard let instance = UINib(nibName: "ChordPanelView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ChordPanelView else {
            return nil
        }
        return instance
    }
    
    @IBAction func noteTouchDown(_ sender: UIButton) {
        self.delegate?.noteTouchDown(sender: sender)
        sender.backgroundColor = UIColor.noteHighlightedBackground
    }
    
    @IBAction func noteTouchUpInside(_ sender: UIButton) {
        self.delegate?.noteTouchUpInside(sender: sender)
        sender.backgroundColor = UIColor.noteDefaultBackground
    }
    @IBAction func noteTouchUpOutside(_ sender: UIButton) {
        self.delegate?.noteTouchUpOutside(sender: sender)
        sender.backgroundColor = UIColor.noteDefaultBackground
    }
    
    @IBAction func chordTouchDown(_ sender: UIButton) {
        self.delegate?.chordTouchDown(sender: sender)
        sender.backgroundColor = UIColor.chordHighlightedBackground
    }
    @IBAction func chordTouchUpInside(_ sender: UIButton) {
        self.delegate?.chordTouchUpInside(sender: sender)
        sender.backgroundColor = UIColor.chordDefaultBackground
    }
    @IBAction func chordTouchUpOutside(_ sender: UIButton) {
        self.delegate?.chordTouchUpOutside(sender: sender)
        sender.backgroundColor = UIColor.chordDefaultBackground
    }    
}

protocol DrumKitPanelDelegate {
    func playDrum(sender: UIButton)
    func touchUpInside()
    func touchUpOutside()
}

class DrumKitPanelView: UIView {
    var delegate: DrumKitPanelDelegate?
    
    class func instanceFromNib() -> DrumKitPanelView? {
        guard let instance = UINib(nibName: "DrumKitPanelView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? DrumKitPanelView else {
            return nil
        }
        return instance
    }
    
    @IBAction func playDrum(_ sender: UIButton) {
        self.delegate?.playDrum(sender: sender)
    }
    @IBAction func touchUpInSide(_ sender: Any) {
        self.delegate?.touchUpInside()
    }
    
    @IBAction func touchUpOutSide(_ sender: Any) {
        self.delegate?.touchUpOutside()
    }
    
}

