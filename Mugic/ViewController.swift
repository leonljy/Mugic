//
//  ViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 1. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {

    @IBOutlet weak var recordStatusLabel: UILabel!
    var noteValue: Int = 0
    var conductor = Conductor()
    var recorder = Recorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func noteTouchDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor.noteHighlightedBackground
        self.noteValue = sender.tag
    }
    
    @IBAction func chordTouchDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor.chordHighlightedBackground
        guard let note = Note(rawValue: self.noteValue), let chord = Chord(rawValue: sender.tag) else {
            return
        }
        
        self.conductor.play(root: note, chord: chord)
        self.recorder.save(root: note, chord: chord)
    }
    
    @IBAction func chordTouchUpOutside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.chordDefaultBackground
        
    }
    @IBAction func chordTouchUpInside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.chordDefaultBackground
    }
    @IBAction func noteTouchUpInside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.noteDefaultBackground
        self.noteValue = 0
    }
    @IBAction func noteTouchUpOutside(_ sender: UIButton) {
        sender.backgroundColor = UIColor.noteDefaultBackground
        self.noteValue = 0
        
    }
    
    @IBAction func handleRecord(_ sender: Any) {
        if self.recorder.isRecording {
            recorder.stopRecord()
        } else {
            recorder.showCount(countBlock: { (timeInterval) in
                //TODO: Calculate Remain Count
                self.recordStatusLabel.text = "\(5-Int(timeInterval))"
            }) { (timeInterval) in
                self.recordStatusLabel.text = "\(timeInterval.timeString())"
            }
        }
    }
    
}

