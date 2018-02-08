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

    var noteValue: Int = 0
    var conductor = Conductor()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func noteTouchDown(_ sender: UIButton) {
        self.noteValue = sender.tag
    }
    
    @IBAction func chordTouchDown(_ sender: UIButton) {
        guard let note = Note(rawValue: self.noteValue), let chord = Chord(rawValue: sender.tag) else {
            return
        }
        
        self.conductor.piano.play(root: note, chord: chord)
    }
    
    @IBAction func chordTouchUpOutside(_ sender: Any) {
    }
    @IBAction func chordTouchUpInside(_ sender: Any) {
    }
}

