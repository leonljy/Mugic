//
//  SongTableViewCell.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 7. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var trackCountLabel: UILabel!
    @IBOutlet weak var timeSignatureLabel: UILabel!
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var song: Song? {
        didSet {
            guard let song = self.song else {
                return
            }
            if let tracks = song.tracks {
                self.trackCountLabel.text = "\(tracks.count) track(s)"
            } else {
                self.trackCountLabel.text = "0 tracks"
            }
            self.timeSignatureLabel.text = "\(song.timeSignatureString)"
            self.tempoLabel.text = "\(song.tempo) bpm"
        }
    }
}
