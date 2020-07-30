//
//  MelodyPanelView.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/04/26.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

protocol MelodyPanelDelegate {
    func melodyTouchDown(sender: UIButton)
    func melodyTouchUpInside(sender: UIButton)
    func melodyTouchUpOutside(sender: UIButton)
}

class MelodyPanelOneOctaveView: UIView {}

class MelodyPanelView: UIView {
    @IBOutlet weak var lowOctave: MelodyPanelOneOctaveView!
    @IBOutlet weak var midOctave: MelodyPanelOneOctaveView!
    @IBOutlet weak var highOctave: MelodyPanelOneOctaveView!
    var delegate: MelodyPanelDelegate?
    
    
    
    class func instanceFromNib() -> MelodyPanelView? {
        guard let instance = UINib(nibName: "MelodyPanelView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MelodyPanelView else {
            return nil
        }
        return instance
    }
    
    @IBAction func melodyTouchDown(_ sender: UIButton) {
        self.delegate?.melodyTouchDown(sender: sender)
        sender.backgroundColor = UIColor.chordHighlightedBackground
    }
    
    @IBAction func melodyTouchUpInside(_ sender: UIButton) {
        self.delegate?.melodyTouchUpInside(sender: sender)
        sender.backgroundColor = self.isWhiteKey(keyboardNumber: sender.tag) ? UIColor.pianoWhiteKey : UIColor.pianoBlackKey
    }
    @IBAction func melodyTouchUpOutside(_ sender: UIButton) {
        self.delegate?.melodyTouchUpOutside(sender: sender)
        sender.backgroundColor = self.isWhiteKey(keyboardNumber: sender.tag) ? UIColor.pianoWhiteKey : UIColor.pianoBlackKey
    }
    
    func isWhiteKey(keyboardNumber: Int) -> Bool {
        switch keyboardNumber {
            case 49, 51, 54, 56, 58, 61, 63, 66, 68, 70, 73, 75, 78, 80, 82:
                return false
            default:
                return true
        }
    }
    
}
