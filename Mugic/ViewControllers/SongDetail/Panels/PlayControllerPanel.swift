//
//  PlayControllerPanel.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/04/26.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

protocol PlayControllerPanelDelegate {
    func panel(_ panel: PlayControllerPanel, didPlayButtonTouched sender: UIButton)
    func panel(_ panel: PlayControllerPanel, didRecordButtonTouched sender: UIButton)
}

@IBDesignable
class PlayControllerPanel: UIView {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var delegate: PlayControllerPanelDelegate?
    
    @IBAction func handleRecordOrStop(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.panel(self, didRecordButtonTouched: sender)
    }
    
    @IBAction func handlePlay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.panel(self, didPlayButtonTouched: sender)
    }
}
