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

//MARK: Count-in related functions
extension Song {
    var beatInterval: TimeInterval {
        get {
            let oneMinute = 60.0
            return TimeInterval(oneMinute / Double(self.tempo)) / Double(self.countInCycle())
        }
    }
    
    var countInTime: TimeInterval {
        get {
            let countInNumber = self.subdivision()
            let countInCycle = self.countInCycle()
            let countInTime = self.beatInterval * Double(countInNumber) * Double(countInCycle)
            print(countInTime)
            return countInTime
        }
    }
    
    func subdivision() -> Int {
        let subdivision: Int
        guard let timeSignature = TimeSignature(rawValue: Int(self.timeSignature)) else {
            return 0
        }
        switch timeSignature {
        case TimeSignature.TwoTwo, TimeSignature.TwoFour:
            subdivision = 2
        case TimeSignature.ThreeFour:
            subdivision = 3
        case TimeSignature.FourFour:
            subdivision = 4
        case TimeSignature.SixEight:
            subdivision = 6
        case TimeSignature.EightTwelve:
            subdivision = 12
        }
        return subdivision
    }
    
    func countInCycle() -> UInt {
        let countInCycle: UInt
        guard let timeSignature = TimeSignature(rawValue: Int(self.timeSignature)) else {
            return 0
        }
        switch timeSignature {
        case TimeSignature.TwoTwo, TimeSignature.TwoFour, TimeSignature.ThreeFour, TimeSignature.FourFour:
            countInCycle = 1
        case TimeSignature.SixEight, TimeSignature.EightTwelve:
            countInCycle = 2
        }
        return countInCycle
    }
}
