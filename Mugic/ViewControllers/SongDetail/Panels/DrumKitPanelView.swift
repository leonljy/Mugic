//
//  DrumKitPanel.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/04/26.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

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
