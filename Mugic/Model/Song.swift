//
//  Model.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 3. 11..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation

//2/2 박자 : two-two time", "2/4 박자 : two-four time(quarter)", "3/4 박자 : three-four time(quarter)", "4/4 박자 : four-four time(quarter)
enum TimeSignature: Int {
    case FourFour = 0
    case ThreeFour
    case TwoFour
    case SixEight
    case EightTwelve
    case TwoTwo
}


class Song {
    var name = "Song"
    var tempo = 90
    var timeSignature = TimeSignature.FourFour
    var instruments = [Instrument]()
}



/*
final class Song: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    let Instruments = List<InstrumentModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class InstrumentModel: Object {
    @objc dynamic var name = ""
    @objc dynamic var typeValue = InstrumentType.Piano.rawValue
    var type: InstrumentType {
        get {
            return InstrumentType(rawValue: self.typeValue)!
        }
        set {
            self.typeValue = newValue.rawValue
        }
    }
    let events = List<Event>()
}

final class Event: Object {
    @objc dynamic var type = ""
    @objc dynamic var time = 0
    @objc dynamic var action = ""
}
*/
