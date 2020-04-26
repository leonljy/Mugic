//
//  PianoPanelView.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/04/26.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

protocol PianoPanelDelegate {
    func melodyTouchDown(sender: UIButton)
    func melodyTouchUpInside(sender: UIButton)
    func melodyTouchUpOutside(sender: UIButton)
}

class PianoPanelOneOctaveView: UIView {}

class PianoPanelView: UIView {
    @IBOutlet weak var lowOctave: PianoPanelOneOctaveView!
    @IBOutlet weak var midOctave: PianoPanelOneOctaveView!
    @IBOutlet weak var highOctave: PianoPanelOneOctaveView!
    var delegate: PianoPanelDelegate?
    
    
    
    class func instanceFromNib() -> PianoPanelView? {
        guard let instance = UINib(nibName: "PianoPanelView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? PianoPanelView else {
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
