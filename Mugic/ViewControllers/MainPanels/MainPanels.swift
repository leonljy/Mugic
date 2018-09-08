//
//  MainPanels.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 8. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

protocol InstrumentSelectionDelegate {
    func selectPanel(_ selected: PanelType)
}


@IBDesignable
class SongInfoPanel: UIView {
    @IBOutlet weak var timeSingnatureLabel: UILabel!
    @IBOutlet weak var beatLabel: UILabel!
    @IBOutlet weak var instrumentSegmentControl: UISegmentedControl!
    
    var delegate: InstrumentSelectionDelegate?
    
    @IBAction func selectPanel(_ sender: UISegmentedControl) {
        let selected = PanelType(rawValue: sender.selectedSegmentIndex)
        self.delegate?.selectPanel(selected!)
    }
    
    
}

@IBDesignable
class PlayControllerPanel: UIView {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var fastforwardButton: UIButton!
    
}
