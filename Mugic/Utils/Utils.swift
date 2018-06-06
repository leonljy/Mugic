//
//  Utils.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 3. 11..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func timeString() -> String {
        //        let hours = Int(time) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i", minutes, seconds)
        //        let ms = Int(timeInterval.truncatingRemainder(dividingBy: 1) * 1000)
        //        return String(format:"%02i:%02i:%02i", minutes, seconds, ms)
    }
}
