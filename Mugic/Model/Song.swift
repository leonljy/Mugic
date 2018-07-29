//
//  Song.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 7. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation


enum TimeSignature: Int {
    case FourFour = 0
    case ThreeFour
    case TwoFour
    case SixEight
    case EightTwelve
    case TwoTwo
}


extension Song {
    var timeSignatureString: String {
        get {
            guard let type = TimeSignature(rawValue: Int(self.timeSignature)) else {
                return ""
            }
            return Song.timeSignatureString(type: type)
        }
    }
    
    static func timeSignatureString(type: TimeSignature) -> String {
        switch type {
        case .FourFour:
            return "4 / 4"
        case .ThreeFour:
            return "3 / 4"
        case .TwoFour:
            return "2 / 4"
        case .SixEight:
            return "6 / 8"
        case .EightTwelve:
            return "8 / 12"
        case .TwoTwo:
            return "2 / 2"
        }
    }
}
