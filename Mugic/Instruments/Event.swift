//
//  Event.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 3. 11..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation

class Event {
//    var type = ""
//    var action = ""
//    var value = ""
    var root: Note
    var chord: Chord
    var time: TimeInterval
    
    init(time: TimeInterval, root: Note, chord:Chord) {
        self.root = root
        self.time = time
        self.chord = chord
    }
//    init(type: String, action:String, value:String, time: TimeInterval) {
//        self.type = type
//        self.action = action
//        self.value = value
//        self.time = time
//    }
}
