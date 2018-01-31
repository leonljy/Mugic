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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let piano = Hit(bass: .C, detail: .maj, amplitude: 0.5)
        piano.play()
    }
    
    @IBAction func minor(_ sender: Any) {
        let piano = Hit(bass: .C, detail: .maj7, amplitude: 0.5)
        piano.play()
    }
    
    @IBAction func sus4(_ sender: Any) {
        let piano = Hit(bass: .C, detail: .seventh, amplitude: 0.5)
        piano.play()
    }
    
    @IBAction func seventh(_ sender: Any) {
        let piano = Hit(bass: .G, detail: .seventh, amplitude: 0.5)
        piano.play()
    }
}

