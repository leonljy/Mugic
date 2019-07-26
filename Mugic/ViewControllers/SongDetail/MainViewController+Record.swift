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
extension MainViewController {
    @IBAction func handleRecordOrStop(_ sender: UIButton) {
        if Recorder.shared.isRecording {
            sender.setTitle("Record", for: .normal)
            Recorder.shared.stopRecord()
            Conductor.shared.stop()
        } else {
            guard let song = self.song, let trackIndex = self.selectedTrackIndex, let track = song.tracks?.object(at: trackIndex) as? Track else {
                self.showAlert(message: "Please select a track first")
                return
            }
            sender.setTitle("On Air", for: .normal)
            track.events = NSSet()
            Recorder.shared.track = track
            print("Start Recording")
            Recorder.shared.startRecord(countInTime: song.countInTime) { (passedTime) in

            }
            Conductor.shared.replay(song: song) {
                Conductor.shared.stop()
            }
        }
    }
    
    @IBAction func handlePlay(_ sender: UIButton) {
        //TODO: Exception There's no song
        print("Start Playing")
        let completionBlock: () -> Void = {
            Conductor.shared.stop()
            sender.setTitle("Play", for: .normal)
        }
        
        guard let song = self.song, !Conductor.shared.isPlaying else {
            completionBlock()
            return
        }
        
        sender.setTitle("Stop", for: .normal)
        
        Conductor.shared.replay(song: song, completionBlock: completionBlock)
    }
}
