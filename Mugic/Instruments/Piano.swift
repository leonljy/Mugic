//
//  Piano.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 6..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

class Piano: ChordInstrument {
    init(midiFileName: String = "Sounds/Piano/Piano") {
        super.init()
        do {
            try self.sampler.loadMelodicSoundFont(midiFileName, preset: 0)
        } catch  {
            print("File not found")
        }
    }
}
