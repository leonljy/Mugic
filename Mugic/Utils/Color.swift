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
            guard let color = UIColor(named: "MugicMain") else { return .clear }
            return color
        }
    }
    
    static var mugicBlack: UIColor {
        get {
            guard let color = UIColor(named: "MugicBlack") else { return .clear }
            return color
        }
    }
    
    static var mugicLightGray: UIColor {
        get {
            guard let color = UIColor(named: "LightGray") else { return .black }
            return color
        }
    }
    
    static var mugicDarkGray: UIColor {
        get {
            guard let color = UIColor(named: "MugicDarkGray") else { return .clear }
            return color
        }
    }
    
    static var mugicWhite: UIColor {
        get {
            guard let color = UIColor(named: "MugicWhite") else { return .clear }
            return color
        }
    }
    
    static var mugicRed: UIColor {
        get {
            guard let color = UIColor(named: "MugicRed") else { return .clear }
            return color
        }
    }
    
    static var mugicYellow: UIColor {
        get {
            guard let color = UIColor(named: "MugicYellow") else { return .clear }
            return color
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
