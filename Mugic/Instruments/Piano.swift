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
    
    init(midifileName: String = "Sounds/Sampler Instruments/sawPiano1") {
        super.init()
        
        do {
            self.midiFileName = midifileName
            try self.sampler.loadEXS24(self.midiFileName)
        } catch  {
            print("File not found")
        }
    }
}
