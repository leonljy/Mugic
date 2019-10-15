//
//  Color.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 13..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    static var noteDefaultBackground: UIColor {
        get {
            return UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        }
    }
    
    static var noteHighlightedBackground: UIColor {
        get {
            return UIColor.black
        }
    }
    
    static var chordDefaultBackground: UIColor {
        get {
            return UIColor(red: 255.0 / 255.0, green: 250.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        }
    }
    
    static var chordHighlightedBackground: UIColor {
        get {
            return UIColor.darkGray
        }
    }
    
    static var pianoWhiteKey: UIColor {
        get {
            return UIColor.white
        }
    }
    
    static var pianoBlackKey: UIColor {
        get {
            return UIColor.black
        }
    }
    
}
