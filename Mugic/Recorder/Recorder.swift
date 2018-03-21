//
//  Recorder.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 3. 8..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation

class Recorder {
    var recording = false
    var timer: Timer = Timer()
    var song: Song
    var startTime = Date()
    var events = [Event]()
    var isRecording: Bool {
        get {
            return self.recording
        }
        
        set {
            self.recording = newValue
        }
    }
    
    init () {
        self.song = Song()
    }
    init (song: Song) {
        self.song = song
    }
    
    func showCount(countBlock: @escaping (_ timeInterval: TimeInterval) -> Void, recordingBlock: @escaping (_ timeInterval: TimeInterval) -> Void) {
        
        let startTime = Date()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            let now = Date()
            let timeInterval = now.timeIntervalSince(startTime)
            //TODO: Change Magic number 4 by song time signature
            if timeInterval > 5 {
                timer.invalidate()
                self.startRecored(timerBlock: recordingBlock)
            } else {
                countBlock(timeInterval)
            }
        })
    }
    
    func startRecored(timerBlock: @escaping (_ timeInterval: TimeInterval) -> Void) {
        self.isRecording = true
        self.startTime = Date()
        self.events = [Event]()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            let now = Date()
            timerBlock(now.timeIntervalSince(self.startTime))
        })
    }
    
    func stopRecord() {
        guard self.isRecording else {
            return
        }
        
        self.isRecording = false
        self.timer.invalidate()
    }
    
    func save(root: Note, chord: Chord) {
        guard self.isRecording else {
            return
        }
        let now = Date()
        let timeInterval = now.timeIntervalSince(self.startTime)
        print("\(timeInterval) => \(root.rawValue) \(chord.rawValue) Pressed")
        let event = Event(time: timeInterval, root: root, chord: chord)
        self.events.append(event)
    }
}
