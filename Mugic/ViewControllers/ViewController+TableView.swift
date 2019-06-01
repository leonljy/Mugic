//
//  ViewController+TableView.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 9. 26..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        guard self.songs.count > 0, let trackCount = self.songs[tableView.tag].tracks?.count else {
            return 0
        }
        return trackCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTrackTableViewCell") as? AddTrackTableViewCell else {
                return UITableViewCell()
            }
            cell.addButton.addTarget(self, action: #selector(ViewController.handleAddTarck), for: .touchUpInside)
            cell.addButton.tag = tableView.tag
            return cell
        }
        let song = self.songs[tableView.tag]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell") as? TrackTableViewCell, let tracks = song.tracks, let track = tracks[indexPath.row] as? Track else {
            return UITableViewCell()
        }
        cell.trackNameLabel.text = track.name
        cell.deleteButton.tag = indexPath.row
        cell.muteButton.tag = indexPath.row
        cell.soloButton.tag = indexPath.row
        cell.changeNameButton.tag = indexPath.row
        cell.changeNameButton.addTarget(self, action: #selector(ViewController.handleChangeTrackName(sender:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(ViewController.handleDeleteTrack), for: .touchUpInside)
        return cell
    }
    
    @IBAction func handleAddTarck(sender: UIButton) {
        guard let managedContext = self.managedContext else {
            return
        }
        let track = Track(context: managedContext)
        track.name = "Track - \(Date())"
        if let selected = self.songInfoPanel?.instrumentSegmentControl.selectedSegmentIndex {
            track.instrument = Int16(selected)
        }
        self.songs[sender.tag].addToTracks(track)
        self.save()
        self.tableViews[sender.tag].reloadData()
    }
    
    @IBAction func handleDeleteTrack(sender: UIButton) {
        let songIndex = self.songIndexByScrollViewContentOffset()
        let song = self.songs[songIndex]
        guard let track = song.tracks?[sender.tag] as? Track else {
            return
        }
        song.removeFromTracks(track)
        self.managedContext?.delete(track)
        self.save()

        if let selectedTrackIndex = self.selectedTrackIndex, selectedTrackIndex >= sender.tag {
            self.selectedTrackIndex = nil
        }
        self.tableViews[songIndex].reloadData()
    }
    
    @IBAction  func handleMuteTrack(sender: UIButton) {
        
    }
    
    @IBAction func handleSoloTrack(sender: UIButton) {
        
    }
    
    @IBAction func handleChangeTrackName(sender: UIButton) {
        let title = "Edit Track Title"
        let message = "Insert New Track Title"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            //Save New Title
            let songIndex = self.songIndexByScrollViewContentOffset()
            let song = self.songs[songIndex]
            guard let track = song.tracks?[sender.tag] as? Track else {
                return
            }
            
            guard let textField = alert.textFields?.first, let title = textField.text else {
                return
            }
            
            track.name = title
            self.save()
            if let cell = self.tableViews[songIndex].cellForRow(at: IndexPath(row: sender.tag, section: 1)) as? TrackTableViewCell {
                cell.trackNameLabel.text = title
            }
        }))
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTrackIndex = indexPath.row
    }
}
