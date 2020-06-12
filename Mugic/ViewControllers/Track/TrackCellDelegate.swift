//
//  TrackCellDelegate.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/06/12.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation

protocol TrackCellDelegate: AnyObject {
    func didTrackVolumeChanged(volume: Double)
    
    func didTrackMuteChanged(isOn: Bool)
    
    func didTrackSoloChanged(isOn: Bool)
}
