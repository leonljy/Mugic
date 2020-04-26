//
//  ChordPanel.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/04/26.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

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
