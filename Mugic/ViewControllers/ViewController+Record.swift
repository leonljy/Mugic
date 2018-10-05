//
//  ViewController+Record.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 9. 26..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit


//Record Extension
extension ViewController {
    @IBAction func handleRecord(_ sender: UIButton) {
        if self.recorder.isRecording {
            sender.setTitle("Record", for: .normal)
            self.recorder.stopRecord()
        } else {
            guard let trackIndex = self.selectedTrackIndex, let track = self.songs[self.songIndexByScrollViewContentOffset()].tracks?.object(at: trackIndex) as? Track else {
                self.showAlert(message: "Please select a track first")
                return
            }
            sender.setTitle("On Air", for: .normal)
            self.recorder.track = track
            self.playExceptSelectedTrack()
            self.recorder.startRecord { (passedTime) in
                
            }
//            self.recorder.showCount(countBlock: { (timeInterval) in
//                //TODO: Calculate Remain Count
//                //                self.recordStatusLabel.text = "\(5-Int(timeInterval))"
//            }) { (timeInterval) in
//                //                self.recordStatusLabel.text = "\(timeInterval.timeString())"
//            }
        }
    }
    
    func playExceptSelectedTrack() {
        guard var tracks = self.songs[self.songIndexByScrollViewContentOffset()].tracks?.array as? [Track] else {
            return
        }
        
        if let selectedTrackIndex = self.selectedTrackIndex {
            tracks.remove(at: selectedTrackIndex)
        }
        
        var mergedEvents: [Event] = []
        for track in tracks {
            if let events = track.events?.allObjects as? [Event] {
                mergedEvents.append(contentsOf: events)
            }
        }
        
        mergedEvents.sort { (a, b) -> Bool in
            return a.time < b.time
        }
        
        self.conductor.replay(events: mergedEvents)
    }
    
    
    @IBAction func handlePlay(_ sender: Any?) {
        guard let tracks = self.songs[self.songIndexByScrollViewContentOffset()].tracks?.array as? [Track] else {
            return
        }
        
        var mergedEvents: [Event] = []
        for track in tracks {
            if let events = track.events?.allObjects as? [Event] {
                mergedEvents.append(contentsOf: events)
            }
        }
        
        mergedEvents.sort { (a, b) -> Bool in
           return a.time < b.time
        }
        
        self.conductor.replay(events: mergedEvents)
    }
    
    @IBAction func handleStop(_ sender: Any) {
//        self.conductor.
    }
}
