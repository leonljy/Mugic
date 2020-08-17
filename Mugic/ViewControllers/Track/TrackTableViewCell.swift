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
            self.changeNameButton.setTitle(track.name, for: .normal)
            self.muteButton.isSelected = self.track?.isMuted ?? false
            self.soloButton.isSelected = self.track?.isSolo ?? false
        }
    }
    weak var delegate: TrackCellDelegate?
    
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var soloButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var volumeProgressBar: UISlider!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var selectionMarkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.mugicDarkGray
        self.selectedBackgroundView = backgroundView
        self.selectionMarkView.layer.cornerRadius = self.selectionMarkView.bounds.width / 2
    }
    
    @IBAction func didChangedTrackVolume(sender: UISlider) {
        let volume = Double(sender.value)
        self.delegate?.didTrackCell(self, volumeChanged: volume)
        self.track?.volume = volume
        self.save()
    }
    
    @IBAction func didMutedChanged(sender: UIButton) {
        guard let isMuted = self.track?.isMuted else {
            return
        }
        self.track?.isMuted = !isMuted
        self.save()
        self.muteButton.isSelected = self.track?.isMuted ?? false
    }
    
    @IBAction func didSoloChanged(sender: UIButton) {
        guard let isSolo = self.track?.isSolo else {
            return
        }
        self.track?.isSolo = !isSolo
        self.save()
        self.soloButton.isSelected = self.track?.isSolo ?? false
        
        guard let newValue = self.track?.isSolo else {
            return
        }
        if newValue {
            self.track?.isMuted = false
            self.muteButton.isSelected = false
        }
    }
    
    @IBAction func handleChangeTrackName(sender: UIButton) {
        guard let track = self.track else {
            return
        }
        self.delegate?.didTrackCell(self, editNameTouched: track)
    }
    
    @IBAction func deleteButtonTouched(sender: UIButton) {
        guard let track = self.track else {
            return
        }
        self.delegate?.didTrackCell(self, deleteTouched: track)
    }
    
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
}


class AddTrackTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
}
