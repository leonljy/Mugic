//
//  EmptyPanelView.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/07/20.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

class EmptyPanelView: UIView {
    @IBOutlet weak var addNewTrackButton: UIButton!
    
    class func instanceFromNib() -> EmptyPanelView? {
        guard let instance = UINib(nibName: "EmptyPanelView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? EmptyPanelView else {
            return nil
        }
        instance.addNewTrackButton.titleLabel?.numberOfLines = 0
        instance.addNewTrackButton.titleLabel?.textAlignment = .center
        return instance
    }
}
