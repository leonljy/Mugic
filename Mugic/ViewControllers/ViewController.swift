//
//  ViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 1. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import UIKit
import AudioKit
import Firebase

enum PanelType: Int {
    case Chord = 0
    case Melody
    case DrumKit
}

class ViewController: UIViewController {

    @IBOutlet weak var eventLabel: UILabel!
    
    let melody = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B" ]
    var noteValue: Int = 0
    var noteString: String?
    var chordString: String?
    var conductor = Conductor()
    var recorder = Recorder()
    
    @IBOutlet weak var panelBackgroundView: UIView!
    
    var chrodPanelView: ChordPanelView?
    var pianoPanelView: PianoPanelView?
    var drumKitPanelView: DrumKitPanelView?
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializePanels()
        
        self.bannerView.adUnitID = "ca-app-pub-9448669804883523/3134031708"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        self.bannerView.alpha = 0.0
        bannerView.delegate = self

        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeLeftAndBottomEdgeTouchDelay()
    }
    
    func removeLeftAndBottomEdgeTouchDelay() {
        if let window = self.view.window, let gestures = window.gestureRecognizers {
            for gesture in gestures {
                gesture.delaysTouchesBegan = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializePanels() {
        self.chrodPanelView = ChordPanelView.instanceFromNib()
        if self.chrodPanelView != nil {
            self.chrodPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.chrodPanelView!)
            self.chrodPanelView?.delegate = self
        }
        
        self.pianoPanelView = PianoPanelView.instanceFromNib()
        if self.pianoPanelView != nil {
            self.pianoPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.pianoPanelView!)
            self.pianoPanelView?.delegate = self
            self.pianoPanelView?.isHidden = true
        }
        
        self.drumKitPanelView = DrumKitPanelView.instanceFromNib()
        if self.drumKitPanelView != nil {
            self.drumKitPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.drumKitPanelView!)
            self.drumKitPanelView?.delegate = self
            self.drumKitPanelView?.isHidden = true
        }
        
    }

    @IBAction func changeMode(_ sender: UISegmentedControl) {
        let panelType = PanelType(rawValue: sender.selectedSegmentIndex)
        switch panelType {
        case .Chord?:
            self.chrodPanelView?.isHidden = false
            self.pianoPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = true
        case .Melody?:
            self.chrodPanelView?.isHidden = true
            self.pianoPanelView?.isHidden = false
            self.drumKitPanelView?.isHidden = true
        case .DrumKit?:
            self.chrodPanelView?.isHidden = true
            self.pianoPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = false
        case .none:
            self.chrodPanelView?.isHidden = false
            self.pianoPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = true
        }
    }
}

//Record Extension
extension ViewController {
    @IBAction func handleRecord(_ sender: Any) {
        if self.recorder.isRecording {
            self.recorder.stopRecord()
        } else {
            self.recorder.showCount(countBlock: { (timeInterval) in
                //TODO: Calculate Remain Count
//                self.recordStatusLabel.text = "\(5-Int(timeInterval))"
            }) { (timeInterval) in
//                self.recordStatusLabel.text = "\(timeInterval.timeString())"
            }
        }
    }
    @IBAction func handlePlay(_ sender: Any) {
        self.conductor.replay(events: self.recorder.events)
    }
}


//Chord Mode Extension {
extension ViewController: ChordPanelDelegate {
    
    func noteTouchDown(sender: UIButton) {
        self.noteValue = sender.tag
        self.noteString = sender.titleLabel?.text
    }
    
    func chordTouchDown(sender: UIButton) {
        guard let note = Note(rawValue: self.noteValue), let chord = Chord(rawValue: sender.tag) else {
            return
        }
        self.chordString = sender.titleLabel?.text
        if let noteString = self.noteString, let chordString = self.chordString {
            self.eventLabel.text = chordString == "Maj" ? noteString : noteString + chordString
        }
        self.conductor.play(root: note, chord: chord)
        self.recorder.save(root: note, chord: chord)
    }
    
    func chordTouchUpOutside(sender: UIButton) {
        self.chordString = nil
        self.eventLabel.text = ""
    }
    
    func chordTouchUpInside(sender: UIButton) {
        self.chordString = nil
        self.eventLabel.text = ""
    }
    
    func noteTouchUpInside(sender: UIButton) {
        self.noteValue = 0
        self.noteString = nil
    }
    
    func noteTouchUpOutside(sender: UIButton) {
        self.noteValue = 0
        self.noteString = nil
        
    }
}

//Melody Mode Extension
extension ViewController: PianoPanelDelegate {
    func melodyTouchDown(sender: UIButton) {
        let tag = sender.tag
        self.conductor.play(note: tag)
        let index = ((tag % 60) % 12)
        
        let melodyString = self.melody[index]
        self.eventLabel.text = melodyString
    }
    func melodyTouchUpInside(sender: UIButton) {
        self.eventLabel.text = ""
    }
    func melodyTouchUpOutside(sender: UIButton) {
        self.eventLabel.text = ""
    }
}

//Drum Mode Extension
extension ViewController: DrumKitPanelDelegate {
    func playDrum(sender: UIButton) { 
        self.eventLabel.text = sender.titleLabel?.text
        self.conductor.playDrum(note: sender.tag)
    }
    
    func touchUpInside() {
        self.eventLabel.text = ""
    }
    
    func touchUpOutside() {
        self.eventLabel.text = ""
    }
}

extension ViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        self.bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.bannerView.alpha = 1
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}



