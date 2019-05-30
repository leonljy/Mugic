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
        
//        self.conductor.replay(events: mergedEvents)
    }
    
    
    @IBAction func handlePlay(_ sender: UIButton) {
        //TODO: Exception There's no song
        guard !self.conductor.isPlaying else {
//            self.conductor.stop()
            sender.setTitle("Play", for: .normal)
            self.conductor.isPlaying = false
            
            return
        }
        sender.setTitle("Stop", for: .normal)
        self.conductor.isPlaying = true
        let songIndex = self.songIndexByScrollViewContentOffset()
        guard let tracks = self.songs[songIndex].tracks?.array as? [Track] else {
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
        
        let timers = self.conductor.eventTimers(events: mergedEvents)
        
        guard let last = mergedEvents.last else {
            return
        }
        let fireDate = Date().addingTimeInterval(TimeInterval(3) + TimeInterval(last.time))
        let timer = Timer(fire: fireDate, interval: 0, repeats: false) { (timer) in
            sender.setTitle("Play", for: .normal)
            self.conductor.isPlaying = false
//            self.conductor.stop()
        }
        let loop = RunLoop.current
        loop.add(timer, forMode: RunLoop.Mode.default)
        
//        self.conductor.
    }
}
