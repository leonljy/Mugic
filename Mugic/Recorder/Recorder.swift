//
//  Recorder.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 3. 8..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Recorder {
    var recording = false
    var timer: Timer = Timer()
    var track: Track
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
        self.track = Track()
    }
    
    init (track: Track) {
        self.track = track
    }
    
    var managedContext: NSManagedObjectContext? {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return nil
            }
            return appDelegate.coreDataStack.managedContext
        }
    }
    
    func showCount(countBlock: @escaping (_ timeInterval: TimeInterval) -> Void, recordingBlock: @escaping (_ timeInterval: TimeInterval) -> Void) {
        
        let startTime = Date()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            let now = Date()
            let timeInterval = now.timeIntervalSince(startTime)
            //TODO: Change Magic number 4 by song time signature
            if timeInterval > 5 {
                timer.invalidate()
                self.startRecord(timerBlock: recordingBlock)
            } else {
                countBlock(timeInterval)
            }
        })
    }
    
    func startRecord(timerBlock: @escaping (_ timeInterval: TimeInterval) -> Void) {
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
        self.track.events = NSSet(array: self.events)
        self.save()
        self.isRecording = false
        self.timer.invalidate()
    }
    
    func save(root: Note, chord: Chord) {
        guard self.isRecording else {
            return
        }
        let now = Date()
        let timeInterval = now.timeIntervalSince(self.startTime)
        
        guard let managedContext = self.managedContext else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "ChordEvent", in: managedContext)!
        if let event = NSManagedObject(entity: entity, insertInto: managedContext) as? ChordEvent {
            event.baseNote = Int16(root.rawValue)
            event.chord = Int16(chord.rawValue)
            event.time = Double(timeInterval)
            self.events.append(event)
            
            self.save()
        }
    }
    
    func save(note: Int) {
        guard self.isRecording else {
            return
        }
        let now = Date()
        let timeInterval = now.timeIntervalSince(self.startTime)
        
        guard let managedContext = self.managedContext else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "MelodicEvent", in: managedContext)!
        if let event = NSManagedObject(entity: entity, insertInto: managedContext) as? MelodicEvent {
            event.note = Int16(note)
            event.time = Double(timeInterval)
            self.events.append(event)
            self.save()
        }
    }
    
    func save(rhythmNote: Int) {
        guard self.isRecording else {
            return
        }
        let now = Date()
        let timeInterval = now.timeIntervalSince(self.startTime)
        
        guard let managedContext = self.managedContext else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "RhythmEvent", in: managedContext)!
        if let event = NSManagedObject(entity: entity, insertInto: managedContext) as? RhythmEvent {
            event.beat = Int16(rhythmNote)
            event.time = Double(timeInterval)
            self.events.append(event)
            self.save()
        }
    }
    
    func save() {
        guard let managedContext = self.managedContext else {
            return
        }
        
        do {
            try managedContext.save()
        } catch {
            
        }
    }
    

}
