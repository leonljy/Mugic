//
//  TrackTableViewCell.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 8. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

class TrackTableViewCell: UITableViewCell {
    
    var track: Track? {
        didSet {
            guard let track = self.track else {
                return
            }
            self.volumeProgressBar.value = Float(track.volume)
        }
    }
    weak var delegate: TrackCellDelegate?
    
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var soloButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var volumeProgressBar: UISlider!
    @IBOutlet weak var changeNameButton: UIButton!
    
    @IBAction func didChangedTrackVolume(sender: UISlider) {
        let volume = Double(sender.value)
        self.delegate?.didTrackVolumeChanged(volume: volume)
        self.track?.volume = volume
        self.save()
    }
    
    @IBAction func didMutedChanged(sender: UIButton) {
        guard let isMuted = self.track?.isMuted else {
            return
        }
        self.track?.isMuted = !isMuted
        self.save()
    }
    
    @IBAction func didSoloChanged(sender: UIButton) {
        guard let isSolo = self.track?.isSolo else {
            return
        }
        self.track?.isSolo = !isSolo
        self.save()
    }
    
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}


class AddTrackTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
}
