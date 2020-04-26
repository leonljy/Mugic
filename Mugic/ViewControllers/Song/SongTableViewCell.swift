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
    @IBOutlet weak var updatedAtLabel: UILabel!
    
    
    var song: Song? {
        didSet {
            guard let song = self.song else { return }
            self.nameLabel.text = song.name
            self.trackCountLabel.text = "\(song.tracks?.count ?? 0) track(s)"
            self.timeSignatureLabel.text = "\(song.timeSignatureString)"
            self.tempoLabel.text = "\(song.tempo) bpm"
            guard let updatedAt = song.updatedAt else { return }
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .short
            self.updatedAtLabel.text = "updated at \(dateformatter.string(from: updatedAt))"
        }
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
        self.tempoLabel.text = "0 bpm"
        self.timeSignatureLabel.text = "0 / 0"
        self.trackCountLabel.text = "0 track(s)"
        self.updatedAtLabel.text = ""
    }
}
