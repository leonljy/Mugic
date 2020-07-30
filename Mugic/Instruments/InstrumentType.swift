//
//  InstrumentType.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/07/20.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation

enum InstrumentType: Int16 {
    case PianoMelody
    case PianoChord
    case GuitarMelody
    case GuitarChord
    case DrumKit
}

extension InstrumentType {
    var panelType: PanelType {
        switch self {
        case .PianoMelody, .GuitarMelody:
            return PanelType.Melody
        case .PianoChord, .GuitarChord:
            return PanelType.Chord
        case .DrumKit:
            return PanelType.DrumKit
        }
    }
    
    var name: String {
        switch self {
        case .PianoMelody:
            return "Piano Melody"
        case .PianoChord:
            return "Piano Chord"
        case .GuitarMelody:
            return "Guitar Melody"
        case .GuitarChord:
            return "Guitar Chord"
        case .DrumKit:
            return "Drum Kit"
        }
    }
}
