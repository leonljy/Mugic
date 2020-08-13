//
//  Guitar.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 2. 6..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import AudioKit

class Guitar: ChordInstrument {
    
    init(midifileName: String = "Acoustic Guitars JNv2.4") {
        super.init()
        self.sampler = AKAppleSampler()
        do {
            try self.sampler.loadMelodicSoundFont(self.midiFileName, preset: 0)
        } catch {
            print("File not found")
        }
    }
}
