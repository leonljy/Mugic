//
//  SongInfoPanel.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/04/26.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit


protocol InstrumentSelectionDelegate {
    func selectPanel(_ selected: PanelType)
}


@IBDesignable
class SongInfoPanel: UIView {
    @IBOutlet weak var instrumentSegmentControl: UISegmentedControl!
    
    var delegate: InstrumentSelectionDelegate?
    
    @IBAction func selectPanel(_ sender: UISegmentedControl) {
        let selected = PanelType(rawValue: Int16(sender.selectedSegmentIndex))
        self.delegate?.selectPanel(selected!)
    }
}
