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
    static var mugicMain: UIColor {
        get {
            return #colorLiteral(red: 0, green: 0.831372549, blue: 0.7764705882, alpha: 1)
        }
    }
    
    static var mugicBlack: UIColor {
        get {
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    static var mugicLightGray: UIColor {
        get {
            return #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        }
    }
    
    static var mugicDarkGray: UIColor {
        get {
            return #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        }
    }
    
    static var mugicWhite: UIColor {
        get {
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    static var mugicRed: UIColor {
        get {
            return #colorLiteral(red: 0.9215686275, green: 0.3529411765, blue: 0.3725490196, alpha: 1)
        }
    }
    
    static var noteDefaultBackground: UIColor {
        get {
            return self.mugicDarkGray
        }
    }
    
    static var noteHighlightedBackground: UIColor {
        get {
            return self.mugicMain
        }
    }
    
    static var chordDefaultBackground: UIColor {
        get {
            return self.mugicDarkGray
        }
    }
    
    static var chordHighlightedBackground: UIColor {
        get {
            return self.mugicMain
        }
    }
    
    static var pianoWhiteKey: UIColor {
        get {
            return self.mugicWhite
        }
    }
    
    static var pianoBlackKey: UIColor {
        get {
            return self.mugicBlack
        }
    }
    
}
