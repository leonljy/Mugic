//
//  TrackCellDelegate.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2020/06/12.
//  Copyright © 2020 Jeong-Uk Lee. All rights reserved.
//

import Foundation

protocol TrackCellDelegate: AnyObject {
    func didTrackCell(_ cell: TrackTableViewCell, volumeChanged volume: Double)
    
    func didTrackCell(_ cell:TrackTableViewCell, muteChanged isMuted: Bool)
    
    func didTrackCell(_ cell: TrackTableViewCell, soloChanged isSolo: Bool)
    
    func didTrackCell(_ cell: TrackTableViewCell, editNameTouched track: Track)
    
    func didTrackCell(_ cell: TrackTableViewCell, deleteTouched track: Track)
}
